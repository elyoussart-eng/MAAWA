"""Adjusts the Android project that `flutter create` generates.

Adds the permissions and receivers the app needs, sets the app name,
and enables core library desugaring (required by flutter_local_notifications).
Works with both Groovy (build.gradle) and Kotlin (build.gradle.kts) templates.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MANIFEST = os.path.join(ROOT, 'android', 'app', 'src', 'main', 'AndroidManifest.xml')

PERMISSIONS = [
    'android.permission.INTERNET',
    'android.permission.ACCESS_COARSE_LOCATION',
    'android.permission.ACCESS_FINE_LOCATION',
    'android.permission.POST_NOTIFICATIONS',
    'android.permission.RECEIVE_BOOT_COMPLETED',
    'android.permission.VIBRATE',
    'android.permission.SCHEDULE_EXACT_ALARM',
]

RECEIVERS = '''
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
            </intent-filter>
        </receiver>
'''


def patch_manifest():
    with open(MANIFEST, encoding='utf-8') as f:
        s = f.read()
    perms = ''.join(f'    <uses-permission android:name="{p}"/>\n' for p in PERMISSIONS if p not in s)
    s = s.replace('<application', perms + '    <application', 1) if perms else s
    s = re.sub(r'android:label="[^"]*"', 'android:label="مأوى"', s, count=1)
    if 'ScheduledNotificationReceiver' not in s:
        s = s.replace('</application>', RECEIVERS + '    </application>', 1)
    with open(MANIFEST, 'w', encoding='utf-8') as f:
        f.write(s)
    print('manifest patched')


def patch_gradle():
    kts = os.path.join(ROOT, 'android', 'app', 'build.gradle.kts')
    groovy = os.path.join(ROOT, 'android', 'app', 'build.gradle')
    if os.path.exists(kts):
        path, flag, dep = kts, 'isCoreLibraryDesugaringEnabled = true', 'coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")'
    elif os.path.exists(groovy):
        path, flag, dep = groovy, 'coreLibraryDesugaringEnabled true', "coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'"
    else:
        sys.exit('No app build.gradle found')
    with open(path, encoding='utf-8') as f:
        s = f.read()
    if 'oreLibraryDesugaringEnabled' not in s:
        if 'compileOptions {' in s:
            s = s.replace('compileOptions {', 'compileOptions {\n        ' + flag, 1)
        else:
            s = s.replace('android {', 'android {\n    compileOptions {\n        ' + flag + '\n    }', 1)
    if 'desugar_jdk_libs' not in s:
        s += '\ndependencies {\n    ' + dep + '\n}\n'
    with open(path, 'w', encoding='utf-8') as f:
        f.write(s)
    print('gradle patched:', os.path.basename(path))


def write_proguard():
    path = os.path.join(ROOT, 'android', 'app', 'proguard-rules.pro')
    rules = '''-keep class com.dexterous.** { *; }
-keep class com.google.gson.reflect.TypeToken
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements java.lang.reflect.Type
'''
    with open(path, 'a', encoding='utf-8') as f:
        f.write(rules)
    print('proguard rules written')


if __name__ == '__main__':
    patch_manifest()
    patch_gradle()
    write_proguard()
