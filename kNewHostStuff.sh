#!/bin/bash
mkdir -p tempstuff/distrowatcher/contents
#copy data
cp -R distrowatcher/contents/* tempstuff/distrowatcher/contents/
cp changelog.txt README LICENSE.GPL3 distrowatcher/metadata.desktop distrowatcher/contents/ui/icons/distrowatcher.png tempstuff/distrowatcher/
#create locale
mkdir -p tempstuff/distrowatcher/contents/locale/el/LC_MESSAGES
mkdir -p tempstuff/distrowatcher/contents/locale/es/LC_MESSAGES
mkdir -p tempstuff/distrowatcher/contents/locale/ru/LC_MESSAGES
mkdir -p tempstuff/distrowatcher/contents/locale/uz/LC_MESSAGES
mkdir -p tempstuff/distrowatcher/contents/locale/it/LC_MESSAGES
mkdir -p tempstuff/distrowatcher/contents/locale/lt/LC_MESSAGES
mkdir -p tempstuff/distrowatcher/contents/locale/de/LC_MESSAGES
mkdir -p tempstuff/distrowatcher/contents/locale/zh_TW/LC_MESSAGES
cp build/el.gmo tempstuff/distrowatcher/contents/locale/el/LC_MESSAGES/org.kde.distrowatcher.mo
cp build/es.gmo tempstuff/distrowatcher/contents/locale/es/LC_MESSAGES/org.kde.distrowatcher.mo
cp build/ru.gmo tempstuff/distrowatcher/contents/locale/ru/LC_MESSAGES/org.kde.distrowatcher.mo
cp build/uz.gmo tempstuff/distrowatcher/contents/locale/uz/LC_MESSAGES/org.kde.distrowatcher.mo
cp build/it.gmo tempstuff/distrowatcher/contents/locale/it/LC_MESSAGES/org.kde.distrowatcher.mo
cp build/lt.gmo tempstuff/distrowatcher/contents/locale/lt/LC_MESSAGES/org.kde.distrowatcher.mo
cp build/de.gmo tempstuff/distrowatcher/contents/locale/de/LC_MESSAGES/org.kde.distrowatcher.mo
cp build/zh_TW.gmo tempstuff/distrowatcher/contents/locale/zh_TW/LC_MESSAGES/org.kde.distrowatcher.mo
cp po/el.po tempstuff/distrowatcher/contents/locale/el/LC_MESSAGES/org.kde.distrowatcher.po
cp po/es.po tempstuff/distrowatcher/contents/locale/es/LC_MESSAGES/org.kde.distrowatcher.po
cp po/ru.po tempstuff/distrowatcher/contents/locale/ru/LC_MESSAGES/org.kde.distrowatcher.po
cp po/uz.po tempstuff/distrowatcher/contents/locale/uz/LC_MESSAGES/org.kde.distrowatcher.po
cp po/it.po tempstuff/distrowatcher/contents/locale/it/LC_MESSAGES/org.kde.distrowatcher.po
cp po/lt.po tempstuff/distrowatcher/contents/locale/lt/LC_MESSAGES/org.kde.distrowatcher.po
cp po/de.po tempstuff/distrowatcher/contents/locale/de/LC_MESSAGES/org.kde.distrowatcher.po
cp po/zh_TW.po tempstuff/distrowatcher/contents/locale/zh_TW/LC_MESSAGES/org.kde.distrowatcher.po
pushd tempstuff
zip -r ../distrowatcher.plasmoid distrowatcher/* 
popd
rm -rf tempstuff