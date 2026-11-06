"""Validate the actual packaged app's identity, minimum OS and extension."""
import plistlib
import sys
from zipfile import ZipFile

with ZipFile(sys.argv[1]) as ipa:
    app = plistlib.loads(ipa.read('Payload/BitChord.app/Info.plist'))
    widget = plistlib.loads(ipa.read('Payload/BitChord.app/PlugIns/BitChordWidget.appex/Info.plist'))
    assert app['CFBundleDisplayName'] == 'OnlyMusic'
    assert app['CFBundleIdentifier'] == 'com.caleb.onlymusic'
    assert widget['CFBundleIdentifier'] == 'com.caleb.onlymusic.widget'
    assert app['MinimumOSVersion'] == '18.0', app['MinimumOSVersion']
    assert 'audio' in app['UIBackgroundModes']
    assert 'onlymusic' in app['CFBundleURLTypes'][0]['CFBundleURLSchemes']
    assert app['OnlyMusicPersonalBuild'] is True
    assert not any(name.endswith('embedded.mobileprovision') for name in ipa.namelist())
    assert ipa.getinfo('Payload/BitChord.app/BitChord').file_size > 0
print('Packaged OnlyMusic iOS 18 app, audio mode and widget identity verified')
