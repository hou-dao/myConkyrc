#!/usr/bin/perl 
#=====================================================================
#
#         FILE:  unread_email.pl
#
#        USAGE:  ./unread_email.pl 
#
#  DESCRIPTION:  Check for unread IMAP email, return sender & subject
#
#      OPTIONS:  none
# REQUIREMENTS:  Mail::IMAPTalk
#         BUGS:  Only checks INBOX
#        NOTES:  ---
#       AUTHOR:  (Stephen Patterson), <steve@patter.mine.nu>
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  23/01/08 10:50:37 GMT
#     REVISION:  ---
#=====================================================================

use strict;
use warnings;
my $username = 'xxx';
my $password = 'xxx';
my $server   = 'xxx';


use Mail::IMAPTalk;

sub find_messages {
    my $IMAP = Mail::IMAPTalk->new( Server   => $server,
            Username => $username,
            Password => $password,
            Uid      => 1 )
        or die "Couldn't connect";

    $IMAP->select('inbox');
    my @MsgIds = $IMAP->search('not', 'seen');

    my @messages;
    foreach my $uid (@MsgIds) {
        my %info = fetch_message($IMAP, $uid);
        push @messages, \%info;
    }
    $IMAP->logout();
    return \@messages;
}

sub fetch_message {
# fetch a message ID, display some information
    my ($IMAP, $uid) = @_;
    my $Msg = $IMAP->fetch($uid, 'envelope')->{$uid}->{envelope};

# clean the sender
    $Msg->{From} =~ s/(")|(<.*>)|(\s{2,})|(\s+$)//g;

# clean the subject
    $Msg->{Subject} =~ s/\[[[:alpha:]]+#\d{6}\]//g;
    $Msg->{Subject} =~ s/(\(.*\))|(\s{2,})|(\s+$)|(^\s+)//g;

    return ( From    => $Msg->{From},
            Subject => $Msg->{Subject});
}

my $messages = find_messages();

my $unread = (scalar (@$messages));
print "Unread: ", $unread, "\n";
if ($unread > 0) {
    foreach my $msg (reverse @$messages) {
        print $msg->{From}, "\n";
       #print $msg->{From}, " - ",
       #      $msg->{Subject}, "\n";

    }
} else {
    print "No mail";
}
