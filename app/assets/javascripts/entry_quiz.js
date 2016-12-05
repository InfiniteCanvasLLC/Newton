

var questions = [
// First question
    {
        text: "What do you feel was the best era of music?",
        replies: [ "2000s", "1990s", "1980s", "1970s or earlier"]
    },
// Second question
    {
        text: "Where do you listen to most of your music?",
        replies: [ "While travelling (eg: car, plane, train, etc)", "At work", "At the club", "At the gym"]
    },
// Third question
    {
        text: "Which one of these songs do you like better?",
        videos: [ "GKSRyLdjsPA", "oRrq6zXFUKg" ],
        replies: [ "Left", "Right" ]
    }
]

var answers = []

var INVALID_INDEX = -1;

var answer_index = INVALID_INDEX;
var cur_question = 0;

function EntryQuizViewModel()
{
    var self = this;

    self.questionText = ko.observable(questions[cur_question].text);
    self.questionReplies = ko.observableArray(questions[cur_question].replies);

    self.showIntro = ko.observable(true);

    self.getStarted = function() {
        self.showIntro(false);
    }

    self.radioButtonClicked = function(radioButton, event) {
        $("#next-button").addClass("active");
        $("#next-button").removeClass("disabled");

        answer_index = $(event.target).attr("answerindex");

        return true;
    }

    self.nextButtonClicked = function() {
        answers[cur_question] = parseInt(answer_index);
        cur_question++;

        self.questionText(questions[cur_question].text);
        self.questionReplies(questions[cur_question].replies);

        $("#next-button").addClass("disabled");
        $("#next-button").removeClass("active");
    }
}

ko.applyBindings(new EntryQuizViewModel());

var player, playing = false;

function onYouTubeIframeAPIReady()
{
    console.log("iFrame API is ready");
/*
    videoId = "1vTCXfX5ivY";
    videoDivId = "video-source";

    player = new YT.Player(videoDivId, {
        height: 100,
        width: 175,
        videoId: videoId,
        playerVars: { 'autoplay' : 1 },
        events: {
            'onReady' : onPlayerReady,
            'onStateChange': onPlayerStateChange
        }
    });
*/
}