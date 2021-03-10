$('document').ready(function() {
	alerts = {};
	var i = 0;
	var notis = [];

    alerts.BaseAlert = function(style, info) {
        switch(style) {
            case 'police':
                alerts.PoPo(info)
            break;
        }
    };

    alerts.PoPo = function(info) {
        i++;
        notis.push("z" + i);
        var html;
        if (info["type"] == "red") {
            var html = '<div class="alerts police red" id="z' + i + '">\n' +
                '  <div class="content">\n' +
                '    <div id="codered">' + info["code"] + '</div>\n' +
                '    <div id="alert-name">' + info["name"] + '</div>\n' +
                '    <div id="marker"><i class="' + info["icon"] + '" aria-hidden="true"></i></div>\n' +
                '    <div id="alert-info"><i class="fas fa-globe-europe"></i>' + info["loc"] + '</div>\n' +
                '  </div>\n' +
                '</div>';
        } else if (info["type"] == "carjack") {
            var html = '<div class="alerts police" id="z' + i + '">\n' +
                '  <div class="content">\n' +
                '    <div id="code">' + info["code"] + '</div>\n' +
                '    <div id="alert-name">' + info["name"] + '</div>\n' +
                '    <div id="marker"><i class="' + info["icon"] + '" aria-hidden="true"></i></div>\n' +
                '    <div id="alert-info"><i class="fas fa-globe-europe"></i>' + info["veh"] + '  |  ' + info["loc"] + '</div>\n' +
                '  </div>\n' +
                '</div>';
        } else {
            var html = '<div class="alerts police" id="z' + i + '">\n' +
                '  <div class="content">\n' +
                '    <div id="code">' + info["code"] + '</div>\n' +
                '    <div id="alert-name">' + info["name"] + '</div>\n' +
                '    <div id="marker"><i class="' + info["icon"] + '" aria-hidden="true"></i></div>\n' +
                '    <div id="alert-info"><i class="fas fa-globe-europe"></i>' + info["loc"] + '</div>\n' +
                '  </div>\n' +
                '</div>';
        }

        $('.alerts-wrapper').append(html);
        $("#z" + i).hide().fadeIn(500);

        if (notis.length > 4) {
            var list = document.getElementById(notis[0]);
            $("#" + notis[0]).fadeOut(500);
            notis.shift();
            setTimeout(function () {
                list.parentNode.removeChild(list);
            }, 600);
        } else {
            setTimeout(function () {
                var list = document.getElementById(notis[0]);
                $("#" + notis[0]).fadeOut(500);
                notis.shift();
                setTimeout(function () {
                    list.parentNode.removeChild(list);
                }, 600);
            }, 15000);
        }
    };

	window.addEventListener('message', function(event) {
		//console.log(event.data.action + " " + event.data.style + " " + event.data.info)
        switch(event.data.action) {
            case 'display':
                //console.log("We've been called for this one")
                alerts.BaseAlert(event.data.style, event.data.info)
            break;
        }
    });
});