use strict;

require LWP::UserAgent;

my $oid = '00DE0000000Y5nO';
my $first_name = 'Lily';
my $last_name = 'Brown';
my $email = "brown\@aol.com";
my $company = 'AOL';
my $website = 'http://www.aol.com';
my $addr = '200 S. Broad st, 
            suite 415, 
            Philadelphia, PA 19104';
my $acc = '2m7F4eTzrdedeMMd';

my $browser = LWP::UserAgent->new;
my $response = $browser->post(
        'https://www.salesforce.com/servlet/servlet.WebToLead?encoding=UTF-8',
        [
        'oid'           => $oid,
        'first_name'    => $first_name,
        'last_name'     => $last_name,
        'email'         => $email,
        'company'       => $company,
        'Website'       => 'aol.com',
        'AdCopy_ID__c'  => $acc,
        'phone'         => '2155889820',
        'street'        => $addr,
        #'street'        => '200 S.Broad st Suite 415',
        #'city'          => 'Philadelphia',
        #'state'         => 'PA',
        #'country'       => 'US',
        ],
);

die "Did not successfully store data in Salesforce" unless $response->is_success;

print $response->content;
