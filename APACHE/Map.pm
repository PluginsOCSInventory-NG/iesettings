
 
package Apache::Ocsinventory::Plugins::Iesettings::Map;
 
use strict;
 
use Apache::Ocsinventory::Map;

$DATA_MAP{iesettings} = {
		mask => 0,
		multi => 1,
		auto => 1,
		delOnReplace => 1,
		sortBy => 'PROXYSERVER',
		writeDiff => 0,
		cache => 0,
		fields => {
                LASTSESSION => {},
                SID => {},
                PROXYENABLE => {},
                AUTOCONFIGURL => {},
                PROXYSERVER => {}
	}
};

1;
