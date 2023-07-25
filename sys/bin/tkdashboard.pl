
use strict;

use Tk;
use DBI;

use DBD::Oracle;

use DashUtils;


my $mw;



# Main Window
 checkVersion();
 $mw = new MainWindow;
 $mw->title("Daily Checks");
my $label = $mw -> Label(-text=>"Daily Checks") -> pack();
my $label1 = $mw -> Button(-text=>"Materialised Views ",
        		-command => [ \&checkMVOld , $mw ]) -> pack(-side => 'top', -fill => 'x');
my $labelMVMSCRM = $mw -> Button(-text=>"Materialised Views (MSCRM)",
        		-command => [ \&checkMVMSCRM , $mw ]) -> pack(-side => 'top', -fill => 'x');
my $button9 = $mw -> Button(-text=>"BAAN Sales Load", 
		-command => [\&checkBAANSalesLoad, $mw ] ) -> pack(-side => 'top', -fill => 'x');
my $button10 = $mw -> Button(-text=>"BAAN Rejections", 
		-command => [ \&showBAANRejections, $mw ] ) -> pack(-side => 'top', -fill => 'x');
my $label8 = $mw -> Button(-text=>"DBA Checks", 
		-command => \&DBAChecks ) -> pack(-side => 'top', -fill => 'x');
my $button = $mw -> Button(-text => "Quit", 
		-command => sub { exit })
	-> pack();
MainLoop;

sub DBAChecks {
    
    my $w=$mw-> Toplevel(-title => "DBA Checks");
    my $Button1 = $w -> Button(-text=>"PIAS DWH (Be)",
        		-command => [ \&checkPiasBe , $w ]) -> pack(-side => 'top', -fill => 'x');
    my $Button2 = $w -> Button(-text=>"PIAS DWH (UK)",
        		-command => [ \&checkPiasUK , $w ]) -> pack(-side => 'top', -fill => 'x');
    my $Button3 = $w -> Button(-text=>"Counterpoint",
        		-command => [ \&checkCounterpoint ,$w ]) -> pack(-side => 'top', -fill => 'x');
    
    
}

sub checkPiasBe {
    my $topLevel=shift;
    my $dbh=connectPias();
    print "Connected\n";
    checkDB ( "PIAS EU DWH", $topLevel, $dbh );
}
sub checkPiasUK {
    my $topLevel=shift;
    my $dbh=connectVital();
    print "Connected\n";
    checkDB ( "PIAS UK DWH", $topLevel, $dbh );
}
sub checkCounterPoint {
    my $topLevel=shift;
    my $dbh=connectREMA();
    print "Connected\n";
    checkDB ( "Counterpoint", $topLevel, $dbh );
}

sub checkDB {
    my $title=shift;
    my $topLevel=shift;
    my $dbh=shift;
    print "CheckDB\n";
    $topLevel->title($title);
    my $label = $topLevel -> Label(-text=>"DBA Checks") -> pack();
    my $label1 = $topLevel -> Button(-text=>"Tablespace",
        		-command => [ \&freeSpaceByTablespace , $topLevel, $dbh ]) -> pack(-side => 'top', -fill => 'x');
    my $label2 = $topLevel -> Button(-text=>"Rollback Segment",
        		-command => [ \&rollbackSegmentStatus , $topLevel, $dbh ]) -> pack(-side => 'top', -fill => 'x');



    # close button 
    my $button = $topLevel -> Button(-text => "Quit", 
		-command => sub { $dbh->disconnect; $topLevel->destroy; })
	-> pack();
#    my $button = $topLevel -> Button(-text => "Quit",
#		-command => [ $topLevel => 'destroy'] )
#	-> pack();
#    $dbh->disconnect;
}


sub checkPiasItems {
#  query the mv views
     checkMaxToPiasLogs($mw,"MAX_TO_PIAS_FULL_LOAD_PKG.LOAD_PIAS_ITEMS","PIAS Item Load (REMA) Status");
}

sub checkSonyInvoicedSalesLoad {
#  query the mv views
     checkMaxToPiasLogs($mw,"THE_TO_PIAS_FULL_LOAD_PKG.LOAD_PIAS_STOCK_OUT","Sony Invoiced Sales Load Status");
}

sub checkSonyStockInLoad {
#  query the mv views
     checkMaxToPiasLogs($mw,"THE_TO_PIAS_FULL_LOAD_PKG.LOAD_PIAS_SONY_STOCK_IN","Sony Stock In Load Status");
}

sub checkSonyCustomerLoad {
#  query the mv views
#    $mw ->messageBox(-message=>"No information available",
#                     -title=>"Sony Customer Load",
#                     -type=>'ok')
     checkMaxToPiasLogs($mw,"THE_TO_PIAS_FULL_LOAD_PKG.LOAD_PIAS_CUSTOMERS","Sony Customer Load Status");
}

sub checkSonyProductLoad {
#  query the mv views
    $mw ->messageBox(-message=>"No information available",
                     -title=>"Sony Product Load",
                     -type=>'ok');
#     checkMaxToPiasLogs("MAX_TO_PIAS_FULL_LOAD_PKG.LOAD_PIAS_ITEMS","Sony Invoiced Sales Load Status");
}

sub checkSonyStockPositionLoad {
#  query the mv views
     checkMaxToPiasLogs($mw,"THE_TO_PIAS_FAST_LOAD_PKG.LOAD_SONY_STOCK_POSITION","Sony Stock Position Load Status");
}





sub testSubRoutine {
#  query the mv views
   my $mw=shift;
   
   my $w=$mw-> Toplevel(-title => "Test Subroutine");
    my ($header)=$w-> Label(-text=>'Date  :Error',
			       -anchor => 'w',
                               -justify => 'right')
                ->pack( -side=>'top',-fill => 'x');
}






