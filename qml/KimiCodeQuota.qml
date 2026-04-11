import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import NERvGear 1.0 as NVG
import NERvGear.Templates 1.0 as T

T.Widget {
    id: widget
    
    // Data
    property int weeklyUsed: 0
    property int rateLimitUsed: 0
    property int resetHours: 0
    property int rateResetHours: 0
    property bool isLoading: false
    property string statusMessage: "点击刷新"
    property bool needsLogin: false
    property var lastLoginAttempt: 0
    readonly property int loginCooldownMs: 30000  // 30 seconds cooldown
    
    // Paths
    readonly property string outputPath: Qt.resolvedUrl("../server/quota_output.json").toString()
    readonly property string localOutputPath: NVG.Url.toLocalFile(Qt.resolvedUrl("../server/quota_output.json"))
    readonly property string localScriptPath: NVG.Url.toLocalFile(Qt.resolvedUrl("../server/fetch_kimi_quota.py"))
    readonly property string batchPath: NVG.Url.toLocalFile(Qt.resolvedUrl("../server/run_fetch.bat"))
    
    // Settings - trim whitespace from Python path
    readonly property string pythonPath: (widget.settings.pythonPath ?? "python").trim()
    readonly property int refreshIntervalMins: widget.settings.refreshIntervalMins ?? 5
    
    // Colors - white theme
    readonly property color bgColor: "#ffffff"
    readonly property color cardBgColor: "#f0f0f0"
    readonly property color accentColor: "#e0e0e0"
    readonly property color textColor: "#333333"
    readonly property color textSecondary: "#666666"
    readonly property color greenColor: "#00d9ff"
    readonly property color purpleColor: "#e94560"
    readonly property color blueColor: "#3498db"
    readonly property color yellowColor: "#f1c40f"
    
    title: "Kimi Code 配额"
    solid: false
    resizable: false
    implicitWidth: 281
    implicitHeight: 161
    
    menu: Menu {
        Action {
            text: "设置..."
            onTriggered: settingsDialog.active = true
        }
        MenuSeparator {}
        Action {
            text: "立即刷新"
            onTriggered: fetchQuotaData()
        }
        Action {
            text: "登录 Kimi"
            onTriggered: runKimiLogin()
        }
    }
    
    // Background
    Rectangle {
        anchors.fill: parent
        color: bgColor
        radius: 10
        border.color: accentColor
        border.width: 1
    }
    
    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 6
        spacing: 3
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 4
            
            Rectangle {
                width: 6
                height: 6
                radius: 3
                color: needsLogin ? purpleColor : 
                       isLoading ? yellowColor :
                       (weeklyUsed > 0 || rateLimitUsed > 0) ? greenColor : textSecondary
                
                SequentialAnimation on opacity {
                    running: isLoading
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.4; duration: 600 }
                    NumberAnimation { to: 1.0; duration: 600 }
                }
            }
            
            Label {
                text: "Kimi Code 配额"
                font.pixelSize: 12
                font.bold: true
                color: textColor
            }
            
            Item { Layout.fillWidth: true }
            
            // Refresh button
            Rectangle {
                width: 16
                height: 16
                radius: 8
                color: refreshMouse.pressed ? accentColor : "transparent"
                border.color: textSecondary
                border.width: 1
                
                Text {
                    anchors.centerIn: parent
                    text: "\u21bb"
                    font.pixelSize: 8
                    color: textSecondary
                    rotation: isLoading ? 360 : 0
                    
                    RotationAnimation on rotation {
                        running: isLoading
                        loops: Animation.Infinite
                        from: 0
                        to: 360
                        duration: 1000
                    }
                }
                
                MouseArea {
                    id: refreshMouse
                    anchors.fill: parent
                    onClicked: fetchQuotaData()
                }
            }
        }
        
        // Weekly Usage
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            
            // Header row
            RowLayout {
                Label { 
                    text: "本周用量"
                    font.pixelSize: 10
                    color: textSecondary
                }
                Item { Layout.fillWidth: true }
                // No "更多权益" link as requested
            }
            
            // Percentage and reset time row
            RowLayout {
                Label { 
                    text: weeklyUsed + "%"
                    font.pixelSize: 18
                    font.bold: true
                    color: textColor
                }
                Item { Layout.fillWidth: true }
                Label { 
                    text: resetHours > 0 ? resetHours + "小时后重置" : ""
                    font.pixelSize: 10
                    color: textSecondary
                }
            }
            
            // Progress bar
            Rectangle {
                Layout.fillWidth: true
                height: 10
                radius: 1
                color: cardBgColor
                
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.margins: 1
                    width: Math.max(4, (parent.width - 4) * (weeklyUsed / 100))
                    radius: 1
                    color: "#333333"
                    
                    Behavior on width { 
                        NumberAnimation { duration: 300 } 
                    }
                }
            }
        }
        
        // Rate Limit  
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            
            // Header row
            RowLayout {
                Label { 
                    text: "频限明细"
                    font.pixelSize: 10
                    color: textSecondary
                }
                Item { Layout.fillWidth: true }
            }
            
            // Percentage row
            RowLayout {
                Label { 
                    text: rateLimitUsed + "%"
                    font.pixelSize: 18
                    font.bold: true
                    color: textColor
                }
                Item { Layout.fillWidth: true }
                Label { 
                    text: rateResetHours > 0 ? rateResetHours + "小时后重置" : ""
                    font.pixelSize: 10
                    color: textSecondary
                }
            }
            
            // Progress bar
            Rectangle {
                Layout.fillWidth: true
                height: 10
                radius: 1
                color: cardBgColor
                
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.margins: 1
                    width: Math.max(4, (parent.width - 4) * (rateLimitUsed / 100))
                    radius: 1
                    color: "#333333"
                    
                    Behavior on width { 
                        NumberAnimation { duration: 300 } 
                    }
                }
            }
        }
    }
    
    // Settings Dialog
    Loader {
        id: settingsDialog
        active: false
        source: "SettingsDialog.qml"
        onLoaded: {
            item.closing.connect(function() { settingsDialog.active = false })
        }
    }
    
    function fetchQuotaData() {
        isLoading = true
        needsLogin = false
        statusMessage = "获取中..."
        
        // Use Python path from settings (trimmed)
        var pyPath = (widget.settings.pythonPath || "python").trim()
        
        // Run batch file with Python path
        NVG.SystemCall.execute(batchPath, pyPath)
        
        readTimer.start()
    }
    
    function readQuotaFile() {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                isLoading = false
                if (xhr.status === 200 || xhr.status === 0) {
                    var responseText = xhr.responseText
                    if (!responseText || responseText === "") {
                        // No data yet - try to fetch automatically
                        needsLogin = true
                        statusMessage = "点击刷新获取数据"
                        return
                    }
                    try {
                        var data = JSON.parse(responseText)
                        if (data.success) {
                            weeklyUsed = data.weekly || 0
                            rateLimitUsed = data.rate_limit || 0
                            resetHours = data.reset_hours || 0
                            rateResetHours = data.rate_reset_hours || 0
                            needsLogin = false
                            statusMessage = "正常"
                        } else {
                            var errorStr = (data.error || "").toLowerCase()
                            if (errorStr.indexOf("login") >= 0 || 
                                errorStr.indexOf("not logged") >= 0 ||
                                errorStr.indexOf("token") >= 0 ||
                                errorStr.indexOf("auth") >= 0) {
                                needsLogin = true
                                statusMessage = "请先运行 'kimi login'"
                            } else {
                                statusMessage = "错误: " + (data.error || "未知")
                            }
                        }
                    } catch (e) {
                        statusMessage = "点击刷新获取数据"
                    }
                } else {
                    statusMessage = "点击刷新获取数据"
                }
            }
        }
        xhr.open("GET", outputPath)
        xhr.send()
    }
    
    Timer {
        id: readTimer
        interval: 3000
        repeat: false
        onTriggered: readQuotaFile()
    }
    
    Timer {
        id: autoRefreshTimer
        interval: Math.max(60000, (widget.settings.refreshIntervalMins || 5) * 60 * 1000)
        repeat: true
        onTriggered: fetchQuotaData()
    }
    
    // Restart timer when interval setting changes
    onRefreshIntervalMinsChanged: {
        if (autoRefreshTimer.running) {
            autoRefreshTimer.restart()
        }
    }
    
    // Start timer when login issue is resolved
    onNeedsLoginChanged: {
        if (!needsLogin && refreshIntervalMins > 0) {
            autoRefreshTimer.start()
        } else if (needsLogin) {
            autoRefreshTimer.stop()
            // Auto-trigger background login with cooldown
            autoLoginTimer.start()
        }
    }
    
    function runKimiLogin() {
        var now = Date.now()
        if (now - lastLoginAttempt < loginCooldownMs) {
            console.log("Login cooldown active, skipping auto-login")
            return
        }
        lastLoginAttempt = now
        
        statusMessage = "正在自动登录..."
        console.log("Auto-running kimi login in background...")
        
        // Run kimi login with cmd /c - runs command and auto-closes
        NVG.SystemCall.execute("cmd.exe", "/c", "kimi login")
        
        // Wait a bit for login to complete then retry fetching data
        loginRetryTimer.start()
    }
    
    // Timer to delay auto-login slightly to avoid immediate popup on startup
    Timer {
        id: autoLoginTimer
        interval: 500
        repeat: false
        onTriggered: {
            if (needsLogin) {
                runKimiLogin()
            }
        }
    }
    
    // Timer to retry fetching data after login attempt
    Timer {
        id: loginRetryTimer
        interval: 3000  // Wait 3 seconds for login to complete
        repeat: false
        onTriggered: {
            console.log("Retrying fetch after login attempt...")
            fetchQuotaData()
        }
    }
    
    // Delay initial read to allow file to be created
    Timer {
        id: initialReadTimer
        interval: 1000
        repeat: false
        onTriggered: readQuotaFile()
    }
    
    Component.onCompleted: {
        // Check if file exists first
        var xhr = new XMLHttpRequest()
        xhr.open("HEAD", outputPath, true)
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    // File exists, read it
                    readQuotaFile()
                } else {
                    // File doesn't exist, auto-fetch
                    fetchQuotaData()
                }
                // Start auto-refresh timer after initial data check
                if (refreshIntervalMins > 0 && !needsLogin) {
                    autoRefreshTimer.start()
                }
            }
        }
        xhr.send()
    }
}
