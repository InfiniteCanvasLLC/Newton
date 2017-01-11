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

mixpanel.track('Quiz: Initial Load')

function onPlayerStateChange(event)
{
    if (event.data == YT.PlayerState.PLAYING)
    {
        mixpanel.track("Quiz: Video Played", { 'video_id': $(event.target.a).attr("id") });
    }
}

function evaluateVideos()
{
    if (!iFrameAPIReady)
    {
        console.log("Attempting to load iFrame API")
        window.setTimeout(evaluateVideos, 200);
    }
    else
    {
        console.log("Attempting to load videos...");

        videosLoaded = 0;

        for (var curVideo in questions[cur_question].videos)
        {
            videoId = questions[cur_question].videos[curVideo];
            videoDivId = "video-" + curVideo;

            console.log("Attempting to load " + videoId + " into div " + videoDivId)

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
    self.showProgressIndicator = ko.observable(false);
    self.showFacebook = ko.observable(false);

    self.getStarted = function() {
        self.showIntro(false);
        self.showQuestions(true);

        mixpanel.track('Quiz: Get Started')
    }

    self.radioButtonClicked = function(radioButton, event) {
        $("#next-button").addClass("active");
        $("#next-button").removeClass("disabled");

        answer_index = $(event.target).attr("answerindex");

        mixpanel.track('Quiz: Radio Button Clicked', { 'question': cur_question });

        return true;
    }

    self.nextButtonClicked = function() {
        answers[cur_question] = parseInt(answer_index);

        mixpanel.track('Quiz: Next Button Clicked', { 'question': cur_question, 'answer': answers[cur_question] })


        cur_question++;

        $('html,body').animate({
           scrollTop: 0
        });

        if (cur_question == questions.length)
        {
            self.showQuestions(false);
            self.showProgressIndicator(true);

            mixpanel.track('Quiz: Finished Questions')

            $.ajax({
                type: "POST",
                url: "set_entry_quiz_result",
                success: function(data) {
                    setTimeout(function() {
                        self.showProgressIndicator(false);
                        self.showFacebook(true);

                        mixpanel.track('Quiz: At Facebook Login')
                        mixpanel.track_links("#sign-in", "Quiz: Sign In");

                    }, 2000);
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
    console.log("YouTube iFrame API is ready")
    iFrameAPIReady = true;
}

var tag = document.createElement('script');

tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);