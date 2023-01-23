export GAZEBO_MASTER_URI=http://localhost:11345
export GAZEBO_MODEL_DATABASE_URI=http://gazebosim.org/models
export GAZEBO_RESOURCE_PATH=/opt/parrot-sphinx/usr/share/gazebo-7.0:/opt/parrot-sphinx/usr/share/gazebo_models:${GAZEBO_RESOURCE_PATH}
export GAZEBO_PLUGIN_PATH=/opt/parrot-sphinx/usr/lib/gazebo-7.0/plugins:${GAZEBO_PLUGIN_PATH}
export GAZEBO_MODEL_PATH=/opt/parrot-sphinx/usr/share/gazebo-7.0/models:${GAZEBO_MODEL_PATH}
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/parrot-sphinx/usr/lib/gazebo-7.0/plugins
export OGRE_RESOURCE_PATH=/opt/parrot-sphinx/usr/lib/OGRE
