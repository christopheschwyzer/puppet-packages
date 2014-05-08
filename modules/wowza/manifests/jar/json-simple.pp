class wowza::jar::json-simple($version = '1.1.1') {

  require 'wowza'

  helper::script {'install wowza:jar json-simple':
    content => template('wowza/jar/simple-json.sh'),
    unless => "test -f /usr/local/WowzaStreamingEngine/lib/lib-versions/json-simple-${version}.jar",
    user => 'wowza',
  }

}
