require File.dirname(__FILE__) + '/test_helper'

class TestJacker < Test::Unit::TestCase
  def setup
    File.unlink(JACKERDB) if File.exist?(JACKERDB)
  end

  def teardown
    Jacker.destroy
  end
  
  def test_setup_creates_db_file
    Jacker.setup

    assert File.exist?(JACKERDB)
  end

  def test_setup_creates_table
    Jacker.setup

    assert_not_equal 0, SQLite3::Database.new(JACKERDB).execute("PRAGMA table_info('entries')")
  end

  def test_destroy_removes_the_db_file
    Jacker.setup
    Jacker.destroy

    assert !File.exist?(JACKERDB)
  end

  def test_start
    Jacker.setup

    Jacker.start('this is an entry')

    entry = SQLite3::Database.new(JACKERDB).execute("select * from entries")
    
    assert_equal 'this is an entry', entry[0][0]
    assert_nil entry[0][2]
  end

  def test_running_after_start
    Jacker.setup
    
    Jacker.start 'a job'

    assert Jacker.running?
  end

  def test_running_after_stop
    Jacker.setup
    
    Jacker.start 'a job'
    Jacker.stop

    assert !Jacker.running?
  end

  def test_stop
    Jacker.setup
    
    Jacker.start 'a job'
    Jacker.stop

    entry = SQLite3::Database.new(JACKERDB).execute("select * from entries WHERE what='a job'")
    assert_not_nil entry[0][2]
  end

  def test_current_after_start
    Jacker.setup

    Jacker.start 'my current job'

    assert_equal 'my current job', Jacker.current
  end

  def test_current_after_stop
    Jacker.setup

    Jacker.start 'my current job'
    Jacker.stop

    assert_nil Jacker.current
  end

  def test_report
    Jacker.setup
    Jacker.start 'a job'
    Jacker.stop

    a = []
    Jacker.report do |*row|
      a << row
    end

    assert_equal 'a job', a[0][0]
  end
end
