package main;
use strict;
use warnings;
use enoceaniot;

my %ENOCEANIOT_gets = (
	"connect" => "no",
	"publishevent" => ""
);

sub ENOCEANIOT_Initialize($) {
	my ($hash) = @_;

	$hash->{DefFn} = 'ENOCEANIOT_Define';
	$hash->{UndefFn} = 'ENOCEANIOT_Undef';
	$hash->{SetFn} = 'ENOCEANIOT_Set';
	$hash->{GetFn} = 'ENOCEANIOT_Get';
	$hash->{AttrFn} = 'ENOCEANIOT_Attr';
	$hash->{ReadFn} = 'ENOCEANIOT_Read';

	$hash->{AttrList} =
		"orgId gatewayType gatewayId authmethod authtoken";
}

sub ENOCEANIOT_Define($$) {
	my ($hash, $def) = @_;
	my @param = split('[ \t]+', $def);

	#e.g. define myENOIOT ENOCEANIOT
	if(int(@param) < 2) {
		return "too few parameters: define <name> ENOCEANIOT";
	}	

	$hash->{name} = $param[0];

	return undef;
}

sub ENOCEANIOT_Undef($$) {
	my ($hash, $arg) = @_; 
	# nothing to do
	return undef;
}

sub ENOCEANIOT_Set($@) {
	my ($hash, @param) = @_;
	my $rc = 0;
	if(int(@param) < 3)
	{
	   return "set [ENOCEANIOT] needs at least 3 argument. set [ENOCEANIOT] <option> <data>";
	}
	my $name = shift @param;
	my $opt = shift @param;

	if(!defined($ENOCEANIOT_gets{$opt})) 
	{
		my @cList = keys %ENOCEANIOT_gets;
		return "Unknown argument $opt, choose one of " .  join(" ", @cList);
	}
	if($opt eq "connect")
	{
           my $value = join("", @param);
	   if($value eq "yes")
	   {
		if($ENOCEANIOT_gets{$opt} eq "yes")
		{
			return "you are already connected to Watson IoT Platform";
		}
		$rc = initializegateway($attr{$name}{orgId},
				 $attr{$name}{gatewayType},
				 $attr{$name}{gatewayId},
				 $attr{$name}{authmethod},
				 $attr{$name}{authtoken});
		if($rc ne 0)
		{
                   return "Failed to initialize ENOCEANIOT with error $rc";
		}
		
		$rc = connectgateway();
		if($rc ne 0)
		{
                   return "Failed to connect to Watson IoT platform with error $rc";
		}
		$hash->{STATE} = $ENOCEANIOT_gets{$opt} = $value;
		return "Successfully connected to Watson IoT platform";
	   }
	   else
	   {
		#disconnect from Watson IoT Platform
                if($ENOCEANIOT_gets{$opt} eq "yes")
                {
                   $rc = disconnectgateway();
                }
                else
                {
                    return "You are not connected to Watson IoT platform";
                } 
	   }
	}
	if($opt eq "publishevent")
	{
	   if($ENOCEANIOT_gets{"connect"} ne "yes")
           {
              return "You are not connected to Watson IoT platform"; 
           }
           #value is DEVICE TYPE DEVICE ID DATA

           my $DEVTYPE = shift @param;
           my $DEVID = shift @param; 
           my $DATA = join("",@param);	
	   $rc = publishdeviceevent($DEVTYPE,$DEVID,"status","json",$DATA,0);	
	   if($rc ne 0)
	   {
              return "Event publishing failed for $DEVID with error $rc";
	   }
	   $hash->{STATE} = $ENOCEANIOT_gets{$opt} = join($DEVTYPE,$DEVID,$DATA);
	   return "Event succesfully published for $DEVID";
	}

	return "0";
}

sub ENOCEANIOT_Get($@) {
	my ($hash, @param) = @_;
	print @param;	
	if(int(@param) < 1)
	{
		return "get needs at least one argument. get ENOCEANIOT";
	}
	my $name = shift @param;
	#my $opt = shift @param;
	my @cList = keys %ENOCEANIOT_gets;
	return join(" : ", @cList);
}

sub ENOCEANIOT_Attr(@) {
	my ($cmd,$name,$attr_name,$attr_value) = @_;
	if($cmd eq "set") 
	{
		if($attr_name eq "orgId" ||
		   $attr_name eq "gatewayType" ||
		   $attr_name eq "gatewayId" ||
		   $attr_name eq "authmethod" ||
		   $attr_name eq "authtoken")
		{
		   if(length($attr_value) == 0)
		   {
		      my $err = "Invalid value $attr_value for $attr_name.";
		      Log 3, "ENOCEANIOT: ".$err;
		      return $err;
		   }
		} 
		else 
		{
		   return "Unknown attr $attr_name";
		}
	}
	return undef;
}

1;

=pod
=begin html

