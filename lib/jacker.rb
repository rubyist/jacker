require 'rubygems'
require 'sqlite3'
require 'fileutils'

module Jacker
  def self.setup
    return if File.exist?(dbfile)
    db = SQLite3::Database.new(dbfile)
    db.execute("CREATE TABLE IF NOT EXISTS entries(what STRING, start TIMESTAMP, stop TIMESTAMP)")
    db.close
  end

  def self.destroy
    FileUtils.rm_f(dbfile)
  end

  def self.start(what)
    self.with_db do |db|
      db.execute("INSERT INTO entries(what, start) VALUES('#{what}', '#{Time.now.to_s}')")
    end
  end

  def self.stop
    self.with_db do |db|
      db.execute("UPDATE entries SET stop='#{Time.now.to_s}' WHERE stop IS NULL")
    end
  end

  def self.running?
    results = self.with_db do |db|
      db.execute("SELECT COUNT(what) FROM entries WHERE stop IS NULL")
    end
    results.size > 0 && results[0][0].to_i > 0
  end

  def self.current(options={})
    results = self.with_db do |db|
      db.execute("SELECT what, start FROM entries WHERE stop IS NULL")
    end

    return nil if results.empty?

    what, start = results[0][0], Time.parse(results[0][1])
    options[:elapsed] ? "#{what} (#{elapsed(start, Time.now)})" : what
  end

  # rounds up to nearest 15 minute increment
  def self.elapsed(start, stop)
    seconds = ((stop - start) / 60).to_i
    hours = seconds / 60
    minutes = (seconds % 60 + 14) / 15 * 15
    sprintf("%d:%02d", hours, minutes)
  end

  def self.report
    self.with_db do |db|
      db.execute("SELECT * FROM entries WHERE stop IS NOT NULL").each do |entry|
        start = Time.parse(entry[1])
        stop  = Time.parse(entry[2])
        yield(entry[0], start, stop)
      end
    end
  end

  def self.status
    if running?
      "jacking: #{current(:elapsed => true)}"
    else
      "not jacking"
    end
  end

  private
  def self.with_db
    setup
    db = SQLite3::Database.new(dbfile)
    results = yield(db)
    db.close
    results
  end
  
  def self.dbfile
    ENV['JACKERDB'] || File.join(ENV['HOME'], '.jacker.db')
  end
end
