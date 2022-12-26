#DC test to see what DC you are connected to
nltest /dsgetdc:domain.localhost

#Reset DC connection
nltest /SC_RESET:domain.local\domaincontroller

#Query available DCs
nltest /sc_query:domain.local