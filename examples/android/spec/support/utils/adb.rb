module AdbUtil
  def execute_adb(command)
    `adb #{command}`
  end
end
