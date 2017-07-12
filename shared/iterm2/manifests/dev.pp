# Public: Installs iTerm2 beta
#
# Usage:
#
#   include iterm2::dev
#
# or with specific version
#
#   class { 'iterm2::dev':
#     version => '20140421'
#   }
class iterm2::dev($version = '2_9_20160523') {
  package { 'iTerm':
    source   => "https://iterm2.com/downloads/beta/iTerm2-2_9_${version}.zip",
    provider => 'compressed_app'
  }
}
