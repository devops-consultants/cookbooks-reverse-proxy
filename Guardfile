# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"
guard 'foodcritic', :cookbook_paths => '.', :all_on_start => false do
  watch(/attributes\/.+\.rb$/)
  watch(/providers\/.+\.rb$/)
  watch(/recipes\/.+\.rb$/)
  watch(/resources\/.+\.rb$/)
  watch(/^templates\/(.+)/)
  watch('metadata.rb')
end

guard :rubocop do
  watch(/.+\.rb$/)
  watch(/(?:.+\/)?\.rubocop\.yml$/) { |m| File.dirname(m[0]) }
end

guard 'kitchen' do
  watch(/test\/.+/)
  watch(/^recipes\/(.+)\.rb$/)
  watch(/^attributes\/(.+)\.rb$/)
  watch(/^files\/(.+)/)
  watch(/^templates\/(.+)/)
  watch(/^providers\/(.+)\.rb/)
  watch(/^resources\/(.+)\.rb/)
end
