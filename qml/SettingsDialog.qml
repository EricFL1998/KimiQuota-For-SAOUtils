import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import NERvGear 1.0 as NVG

NVG.Window {
    id: dialog
    title: "Kimi Code 设置"
    visible: true
    minimumWidth: 400
    minimumHeight: 420
    width: minimumWidth
    height: minimumHeight
    transientParent: widget.NVG.View.window
    
    Rectangle {
        anchors.fill: parent
        color: "#f5f5f5"
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16
            
            Label {
                text: "Python 路径"
                font.pixelSize: 12
                font.bold: true
                color: "#333333"
            }
            
            TextField {
                id: pythonPathField
                Layout.fillWidth: true
                text: widget.settings.pythonPath || "python"
                color: "#333333"
                placeholderText: "例如: python 或 C:\\Python\\python.exe"
                font.pixelSize: 11
                
                background: Rectangle {
                    color: "#ffffff"
                    radius: 4
                    border.color: "#dddddd"
                    border.width: 1
                }
                
                onEditingFinished: {
                    widget.settings.pythonPath = text.trim()
                }
            }
            
            Label {
                text: "如果无法获取数据，请填写 Python 的完整路径"
                font.pixelSize: 10
                color: "#ff9800"
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#e0e0e0"
            }
            
            Label {
                text: "刷新设置"
                font.pixelSize: 12
                font.bold: true
                color: "#333333"
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                
                Label {
                    text: "自动刷新间隔:"
                    font.pixelSize: 11
                    color: "#666666"
                }
                
                SpinBox {
                    id: intervalSpin
                    from: 1
                    to: 60
                    value: widget.settings.refreshIntervalMins || 5
                    
                    onValueModified: {
                        widget.settings.refreshIntervalMins = value
                    }
                }
                
                Label {
                    text: "分钟"
                    font.pixelSize: 11
                    color: "#666666"
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#e0e0e0"
            }
            
            Label {
                text: "使用说明"
                font.pixelSize: 12
                font.bold: true
                color: "#333333"
            }
            
            Label {
                Layout.fillWidth: true
                text: "1. 安装 Kimi CLI 并登录:"
                font.pixelSize: 10
                color: "#666666"
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 50
                color: "#2d2d3a"
                radius: 4
                
                Text {
                    anchors.fill: parent
                    anchors.margins: 8
                    text: "pip install kimi-cli\nkimi login"
                    font.pixelSize: 10
                    font.family: "Consolas, monospace"
                    color: "#4ade80"
                }
            }
            
            Label {
                Layout.fillWidth: true
                text: "2. 在终端中完成登录后，点击挂件上的刷新按钮"
                font.pixelSize: 10
                color: "#666666"
                wrapMode: Text.Wrap
            }
            
            Item { Layout.fillHeight: true }
            
            Button {
                Layout.alignment: Qt.AlignHCenter
                text: "关闭"
                onClicked: dialog.close()
            }
        }
    }
}
