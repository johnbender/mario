require 'helper'

class TestPlatform < Test::Unit::TestCase
  context "Mario platforms" do
    context 'on any platform' do
      setup do
        Mario::Platform.forced = nil
      end

      should "find at least one os representing a class" do
        assert Mario::Platform.check_group(Mario::Platform.targets)
      end
    end

    context 'when testing for *nix' do
      should 'return true for all known variants' do
        Mario::Platform::nix_group.each do |klass|
          assert check_nix(klass) 
        end
      end
      
      should 'return false for all other' do
        # TODO use relative complement of nix_group in targets
        Mario::Platform::windows_group.each do |klass|
          assert !check_nix(klass)
        end
      end
    end  

    context 'when testing for windows' do
      should 'return true for all known variants' do
        Mario::Platform.windows_group.each do |klass|
          assert check_win(klass)
        end
      end

      should 'return false for others' do 
        # TODO use relative complement of windows_group in targets
        Mario::Platform.nix_group.each do |klass|
          assert !check_win(klass)
        end
      end
    end

    context 'when checking any os with abnormal target strings' do
      should 'handle extranious characters' do
        Mario::Platform.expects(:target_os).twice.returns("12%#{first_os_klass.target}&%$")
        assert check_nix first_os_klass
      end

      should 'handle capitals' do
        Mario::Platform.expects(:target_os).twice.returns(first_os_klass.target.upcase)
        assert check_nix first_os_klass
      end
    end  

    context 'when checking an os' do
      should 'respond positively to each os listed in targets' do
        Mario::Platform.targets.each do |klass|
          Mario::Platform.forced = klass
          assert Mario::Platform.send(klass.to_s.split('::').last.downcase + '?')
        end
      end
    end
    
    context 'when forcing a target os' do
      should 'log at a warning level' do
        logger = mock('logger')
        Mario::Platform.expects(:logger).returns(logger)
        logger.expects(:warn).with do |string| 
          string =~ /#{first_os_klass.target}/ &&  string =~ /#{first_os_klass}/ 
        end
        Mario::Platform.forced = first_os_klass
      end
      
      should 'reset the current os' do
        mock_klass = mock('platform klass')
        Mario::Platform.forced = first_os_klass
        Mario::Platform.expects(:check_group).with(Mario::Platform.targets).returns(mock_klass)
        mock_klass.expects(:new).returns(nil)
        assert !Mario::Platform.current
      end
    end

    context 'checking a group' do
      setup do
        @forced = mock_os_klass('force')
        Mario::Platform.forced = @forced
      end

      should "return the os class itself when found" do
        assert Mario::Platform.check_group([mock_os_klass, @forced, mock_os_klass]) == @forced
      end
      
      should "return once if one is found in a group of classes that respond to target" do
        assert Mario::Platform.check_group([mock_os_klass, @forced, mock_os_klass])
      end

      should "return not return one if non are found" do
        assert !Mario::Platform.check_group([mock_os_klass, mock_os_klass])
      end
    end
  end

  def check_nix(force)
    Mario::Platform.forced = force
    Mario::Platform.nix?
  end

  def check_win(force)
    Mario::Platform.forced = force
    Mario::Platform.windows?
  end

  def first_os_klass
    Mario::Platform.targets.first
  end

  def mock_os_klass(str='foo')
    mock = mock('os klass')
    mock.stubs(:target).returns(str)
    mock
  end
end
