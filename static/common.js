function requestAPI(endpoint, method, data, callback) {
    $.ajax({
        url: endpoint,
        method: method
    }).then(function (response) {
        callback(response, null);
    }).fail(function (error) {
        callback(null, error);
    });
}

function requestCurrentSong(callback) {
    requestAPI("/api/playlist/current", "GET", null, callback);
}

function bind(templateSelector, targetSelector) {
    var dataBind = new Object();
    dataBind.source = $(templateSelector).html();
    dataBind.updateView = function (model) {
        var rendered = this.template(model);
        $(targetSelector).html(rendered);
    };

    dataBind.template = Handlebars.compile(dataBind.source);
    return dataBind;
}

Handlebars.registerHelper('date', function (unixTime) {
    let date = new Date(unixTime * 1000);

    let day = "0" + date.getDate();
    let month = "0" + (date.getMonth() + 1);
    let year = date.getFullYear();
    let hours = "0" + date.getHours();
    let minutes = "0" + date.getMinutes();
    let seconds = "0" + date.getSeconds();

    let formattedTime = day.substr(-2) + "/" + month.substr(-2) + "/" + year + " " +
                        hours.substr(-2) + ':' + minutes.substr(-2) + ':' + seconds.substr(-2);
    return formattedTime
});
