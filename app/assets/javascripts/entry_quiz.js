

var questions = [
// First question
    {
        text: "What do you feel was the best era of music?",
        replies: [ "2000s", "1990s", "1980s", "1970s or earlier"]
    },
// Second question
    {
        text: "Where do you listen to most of your music?",
        replies: [ "While travelling (eg: car, plane, train, etc)", "At home", "At work", "At the club", "At the gym"]
    },
// Third question
    {
        text: "Which one of these songs do you like better?",
        videos: [ "GKSRyLdjsPA", "oRrq6zXFUKg" ],
        replies: [ "Sia - The Greatest", "Pegboard Nerds - Blackout" ]
    }
]

var answers = []

var INVALID_INDEX = -1;

var answer_index = INVALID_INDEX;
var cur_question = 0;
var iFrameAPIReady = false;
var videosLoaded = 0;

function onPlayerStateChange(param)
{
    console.log($(param.target.a).attr("id"));
}

function evaluateVideos()
{
    if (!iFrameAPIReady)
    {
        window.setTimeout(evaluateVideos, 200);
    }
    else
    {
        videosLoaded = 0;

        for (var curVideo in questions[cur_question].videos)
        {
            videoId = questions[cur_question].videos[curVideo];
            videoDivId = "video-" + curVideo;

            player = new YT.Player(videoDivId, {
                height: 300,
                width: 540,
                videoId: videoId,
                events: {
                    'onStateChange': onPlayerStateChange
                }
            });
        }
    }
}

function EntryQuizViewModel()
{
    var self = this;

    self.questionText = ko.observable(questions[cur_question].text);
    self.questionReplies = ko.observableArray(questions[cur_question].replies);
    self.questionVideos = ko.observableArray(questions[cur_question].videos);

    self.showIntro = ko.observable(true);
    self.showQuestions = ko.observable(false);
    self.showFacebook = ko.observable(false);

    self.getStarted = function() {
        self.showIntro(false);
        self.showQuestions(true);
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

        if (cur_question == questions.length)
        {
            self.showQuestions(false);
            self.showFacebook(true);

            $.ajax({
                type: "POST",
                url: "set_entry_quiz_result",
                success: function(data) {
                    console.log("haha");
                },
                data: { 
                    'answers': answers
                }
            });

            return;
        }

        self.questionText(questions[cur_question].text);
        self.questionReplies(questions[cur_question].replies);
        self.questionVideos(questions[cur_question].videos);

        $("#next-button").addClass("disabled");
        $("#next-button").removeClass("active");

        evaluateVideos();
    }
}

ko.applyBindings(new EntryQuizViewModel());

var player, playing = false;

function onYouTubeIframeAPIReady()
{
    iFrameAPIReady = true;
}