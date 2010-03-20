require 'helper'

class TestPlatform < Test::Unit::TestCase
  context "Mario's jumping platforms" do
  
    context 'when testing for *nix' do
      should 'return true for all known variants' do
        Mario::Platform::nix_group.each do |key, value|
          assert check_nix(key) 
        end
      end
      
      should 'return false for all other' do
        # TODO use relative complement of nix_group in targets
        Mario::Platform::windows_group.each do |key, value|
          assert !check_nix(key)
        end
      end
    end  

    context 'when testing for windows' do
      should 'only return true for all known variants' do
        Mario::Platform.windows_group.each do |key, value|
          assert check_win(key)
        end
      end

      should 'return false for others' do 
        # TODO use relative complement of windows_group in targets
        Mario::Platform.nix_group.each do |key, value|
          assert !check_win(key)
        end
      end
    end

    context 'when checking any os with abnormal target strings' do
      should 'handle extranious characters' do
        assert check_nix('12%&linux%#$')
      end

      should 'handle capitals' do
        assert check_nix('LINUX')
      end
    end  

    context 'when checking an os' do
      should 'respond positively to each os listed in targets' do
        Mario::Platform.targets.each do |key, value|
          Mario::Platform.forced = value
          assert Mario::Platform.send(key.to_s + '?')
        end
      end
    end
    
    context 'when forcing a target os' do
      should 'log at a warning level' do
        logger = mock('logger')
        Mario::Platform.expects(:logger).returns(logger)
        logger.expects(:warn).with { |string| string =~ /foo/ }
        Mario::Platform.forced = 'foo'
      end
    end
  end

  def check_nix(force)
    Mario::Platform.forced = Mario::Platform.targets[force]
    Mario::Platform.nix?
  end

  def check_win(force)
    Mario::Platform.forced = Mario::Platform::targets[force]
    Mario::Platform.windows?
  end
end
