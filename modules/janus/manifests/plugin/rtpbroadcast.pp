class janus::plugin::rtpbroadcast(
  $minport = 8000,
  $maxport = 9000,
  $archive_path = '/var/lib/janus/recordings',
  $recording_pattern = 'rec-#{id}-#{time}-#{type}',
  $thumbnailing_pattern = 'thum-#{id}-#{time}-#{type}',
  $thumbnailing_interval = 60,
  $thumbnailing_duration = 10,
  $jobs_path = '/var/lib/janus/jobs',
  $job_pattern = 'job-#{md5}'
) {

  file { '/etc/janus/janus.plugin.rtpbroadcast.cfg':
    ensure    => 'present',
    content   => template("${module_name}/plugin/rtpbroadcast.cfg"),
    owner     => '0',
    group     => '0',
    mode      => '0644',
  }
  ->

  janus::plugin { 'rtpbroadcast': }

}