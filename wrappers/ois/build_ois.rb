require 'rubygems'
require 'rbplusplus'
require 'fileutils'
include RbPlusPlus

OGRE_RB_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))

OIS_DIR = File.join(OGRE_RB_ROOT, "lib", "ois")

HERE_DIR = File.join(OGRE_RB_ROOT, "wrappers", "ois")

Extension.new "ois" do |e|
  e.working_dir = File.join(OGRE_RB_ROOT, "generated", "ois")

  e.sources File.join(OIS_DIR, "include", "OIS", "OIS.h"),
    :include_source_dir => File.join(HERE_DIR, "code"),
    :library_paths => File.join(OIS_DIR, "lib"),
    # For our custom code in code/ to find OIS correctly
    :include_paths => File.join(OIS_DIR, "include"),
    :libraries => "OIS",
    :ldflags => "-shared"

  e.module "OIS" do |m|
    node = m.namespace "OIS"

    # Uses crazy STL stuff, ignore for now
    node.classes("FactoryCreator").ignore

    # Hmm, InputManager has protected destructor, causing problems. Ignore them for now
    node.classes("Object").methods("getCreator").ignore

    node.classes("InputManager").methods("listFreeDevices").ignore

    node.classes("Exception").ignore
  end
end

# At completion, copy over the new ois extension
FileUtils.cp File.join(OGRE_RB_ROOT, "generated", "ois", "ois.so"), File.join(OGRE_RB_ROOT, "lib", "ois")
