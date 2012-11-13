#
# This file should not be required directly. Use it like so:
#
#  Daemons.run('leap_ca_daemon.rb')
#

require 'leap_ca'

module LeapCA
  puts    " * Tracking #{Cert.database.root}"
  couch   = CouchStream.new(Cert.database.root)
  changes = CouchChanges.new(couch)
  pool    = Pool.new(:size => Config.max_pool_size)

  # fill the pool
  pool.fill

  # watch for deletions, fill the pool whenever it gets low
  changes.follow do |hash|
    if hash[:deleted]
      pool.fill
    end
  end
end
