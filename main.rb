# frozen_string_literal: true

require 'English'

require 'yaml'
require 'open3'
require 'fileutils'
require 'pathname'

def get_env_variable(key)
  ENV[key].nil? || ENV[key] == '' ? nil : ENV[key]
end

def env_has_key(key)
  return (ENV[key] != nil && ENV[key] !="") ? ENV[key] : abort("Missing #{key}.")
end

def run_command(command)
  puts "@@[command] #{command}"
  exit $CHILD_STATUS.exitstatus unless system(command)
end

ac_module = env_has_key('AC_MODULE')
ac_variants = env_has_key('AC_VARIANTS')
ac_repo_path = env_has_key('AC_REPOSITORY_DIR')
ac_output_folder = env_has_key('AC_GRADLE_OUTPUT_DIR')
gradle_task = env_has_key('AC_GRADLE_TASK')

ac_gradle_params = get_env_variable('AC_GRADLE_TASK_EXTRA_PARAMETERS') || ''
ac_project_path = get_env_variable('AC_PROJECT_PATH') || '.'

gradlew_folder_path = if Pathname.new(ac_project_path.to_s).absolute?
                        ac_project_path
                      else
                        File.expand_path(File.join(ac_repo_path, ac_project_path))
                      end

build_output_folder = File.join(gradlew_folder_path, "#{ac_module}/build/outputs")
gradle_task = "#{gradle_task} #{ac_gradle_params}" unless ac_gradle_params.strip.empty?

command = "cd #{gradlew_folder_path} && chmod +x ./gradlew && ./gradlew #{gradle_task}"
run_command(command)

puts "Filtering artifacts: #{build_output_folder}/**/*.apk, #{build_output_folder}/**/*.aab"

apks = Dir.glob("#{build_output_folder}/**/*.apk")
aabs = Dir.glob("#{build_output_folder}/**/*.aab")

FileUtils.cp apks, ac_output_folder.to_s
FileUtils.cp aabs, ac_output_folder.to_s

apks = Dir.glob("#{ac_output_folder}/**/*.apk").join('|')
aabs = Dir.glob("#{ac_output_folder}/**/*.aab").join('|')

puts "Exporting AC_APK_PATH=#{apks}"
puts "Exporting AC_AAB_PATH=#{aabs}"

File.open(ENV['AC_ENV_FILE_PATH'], 'a') do |f|
  f.puts "AC_APK_PATH=#{apks}"
  f.puts "AC_AAB_PATH=#{aabs}"
end

exit 0
