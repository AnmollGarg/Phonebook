import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

Page {
    id: splash
    anchors.fill: parent

    signal finished()

    // App sets this when initialization is done.
    property bool loaderReady: false

    // Animation timing
    readonly property int fadeInDuration: 600
    readonly property int fadeOutDuration: 400
    readonly property int spinnerFadeDuration: 250
    readonly property int minDisplayDuration: 1200
    readonly property var easingCurve: Easing.InOutQuad

    // State tracking
    property bool isWaiting: false
    property bool hasFinished: false

    Rectangle {
        anchors.fill: parent
        color: theme.palette.normal.background

        ColumnLayout {
            anchors.centerIn: parent
            spacing: units.gu(3)

            Image {
                id: logo
                source: Qt.resolvedUrl("../../../assets/logo.svg")
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: units.gu(15)
                Layout.preferredHeight: units.gu(15)
                fillMode: Image.PreserveAspectFit
                opacity: 0
            }

            Label {
                id: appName
                text: i18n.tr("OS-OSi-Phonebook")
                Layout.alignment: Qt.AlignHCenter
                fontSize: "x-large"
                font.bold: true
                opacity: 0
            }

            ActivityIndicator {
                id: spinner
                Layout.alignment: Qt.AlignHCenter

                // Runs only when visible enough to matter
                running: opacity > 0.01
                opacity: 0
            }
        }
    }

    SequentialAnimation {
        id: splashAnim

        ParallelAnimation {
            NumberAnimation { target: logo;    property: "opacity"; to: 1; duration: fadeInDuration; easing.type: easingCurve }
            NumberAnimation { target: appName; property: "opacity"; to: 1; duration: fadeInDuration; easing.type: easingCurve }
        }

        NumberAnimation {
            target: spinner
            property: "opacity"
            to: 1
            duration: spinnerFadeDuration
            easing.type: easingCurve
        }

        PauseAnimation {
            id: waitAnimation
            duration: minDisplayDuration

            onStarted: isWaiting = true
            onStopped: isWaiting = false
        }

        ParallelAnimation {
            NumberAnimation { target: logo;    property: "opacity"; to: 0; duration: fadeOutDuration; easing.type: easingCurve }
            NumberAnimation { target: appName; property: "opacity"; to: 0; duration: fadeOutDuration; easing.type: easingCurve }
            NumberAnimation { target: spinner; property: "opacity"; to: 0; duration: fadeOutDuration; easing.type: easingCurve }
        }

        ScriptAction {
            script: {
                if (!hasFinished) {
                    hasFinished = true
                    finished()
                }
            }
        }
    }

    Component.onCompleted: splashAnim.start()


    // Skip if the app initializes early.
    onLoaderReadyChanged: {
        if (loaderReady && !hasFinished && isWaiting) {
            waitAnimation.complete()
        }
    }
}
