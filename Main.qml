import QtQuick 2.8
import QtQuick.Controls 2.8
import QtQuick.Controls 1.4 as Q1
import QtQuick.Controls.Styles 1.4
import SddmComponents 2.0
import QtGraphicalEffects 1.0
import "."

Rectangle {
    id : container
    LayoutMirroring.enabled : Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit : true
    property int sessionIndex : session.index

    TextConstants {
        id : textConstants
    }

    FontLoader {
        id : basefont
        source : "weblysleekuisl.ttf"
    }

    Connections {
        target : sddm
        onLoginSucceeded : {
            errorMessage.color = "#33ff99"
            errorMessage.text = textConstants.loginSucceeded
        }
        onLoginFailed : {
            password.text = ""
            errorMessage.color = "#ff99cc"
            errorMessage.text = textConstants.loginFailed
            errorMessage.bold = true
        }
    }
    Background {
        anchors.fill : parent
        source : config.background
        fillMode : Image.Stretch
        onStatusChanged : {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Column {
        anchors.verticalCenter : parent.verticalCenter
        anchors.horizontalCenter : parent.horizontalCenter
        spacing: 36
        Row{
            spacing: 8
            Text{
                text:"                    "
            }

        Image {
            id : userpic
            source : "assets/users.png"
            height: 190
            width: 190

        }


        }

        Column {
            spacing: 8

            Row {
                spacing: 4

                TextField {
                    id : name
                    font.family : basefont.name
                    width : 320
                    height : 30
                    text : userModel.lastUser
                    font.pointSize : 10
                    color : "#323232"
                    background : Image {
                        source : "assets/input.png"
                    }
                    KeyNavigation.backtab : rebootButton
                    KeyNavigation.tab : password
                    Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(name.text, password.text, sessionIndex)
                            event.accepted = true
                        }
                    }
                }
            }

            Row {
                spacing : 4

                TextField {
                    id : password
                    anchors.verticalCenter : parent.verticalCenter
                    font.pointSize : 10
                    echoMode : TextInput.Password
                    font.family : basefont.name
                    color : "#323232"
                    width : 320
                    height : 30
                    background : Image {
                        source : "assets/input.png"
                    }
                    KeyNavigation.backtab : name
                    KeyNavigation.tab : loginButton
                    Keys.onPressed : {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(name.text, password.text, sessionIndex)
                            event.accepted = true
                        }
                    }
                }
                Image {
                    id : loginButton
                    width : 32
                    height : 32
                    source : "assets/login.png"
                    MouseArea {
                        anchors.fill : parent
                        hoverEnabled : true
                        onEntered : {
                            parent.source = "assets/login-hover.png"
                        }
                        onExited : {
                            parent.source = "assets/login.png"
                        }
                        onPressed : {
                            parent.source = "assets/login-active.png"
                            sddm.login(name.text, password.text, sessionIndex)
                        }
                        onReleased : {
                            parent.source = "assets/login.png"
                        }
                    }
                    KeyNavigation.backtab : password
                    KeyNavigation.tab : shutdownButton
                }
            }
        }
    }
    Column {
        anchors.left : parent.left
        anchors.bottom : parent.bottom
        anchors.leftMargin : 24
        width : 114
        height:64
        spacing: 4

        ComboBox {
            id : session
            width : parent.width
            height : 24
            font.pixelSize : 10
            font.family : basefont.name
            arrowIcon : "assets/comboarrow.svg"
            model : sessionModel
            index : sessionModel.lastIndex
            borderColor : "#0c191c"
            color : "#eaeaec"
            menuColor : "#f4f4f8"
            textColor : "#323232"
            hoverColor : "#36a1d3"
            focusColor : "#36a1d3"
            KeyNavigation.backtab : password
            KeyNavigation.tab : shutdownButton
        }
    }

    Column {
        anchors.bottom : parent.bottom
        anchors.right : parent.right
        anchors.bottomMargin : 0
        anchors.rightMargin : 24
        height: 64
        Row{
        spacing : 0


        Q1.Button {
            id : shutdownButton
            height : 28
            width : 38
            style : ButtonStyle {
                background : Image {
                    source : control.hovered
                        ? "assets/shutdown_pressed.png"
                        : "assets/shutdown.png"
                }
            }
            onClicked : sddm.powerOff()
            KeyNavigation.backtab : loginButton
            KeyNavigation.tab : rebootButton
        }

        Q1.Button {
            id : rebootButton
            height : 28
            width : 20
            style : ButtonStyle {
                background : Image {
                    source : control.hovered
                        ? "assets/rebootpressed.png"
                        : "assets/reboot.png"
                }
            }
            onClicked : sddm.reboot()
            KeyNavigation.backtab : shutdownButton
            KeyNavigation.tab : name
        }
    }
    }

    Component.onCompleted : {
        if (name.text == "")
            name.focus = true
         else
            password.focus = true

    }
}
