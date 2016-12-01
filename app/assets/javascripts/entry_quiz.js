

var questions = [
// First question
    {
        text: "What do you feel was the best era of music?",
        replies: [ "2000s", "1990s", "1980s", "1970s or earlier"]
    }
]

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
}

ko.applyBindings(new EntryQuizViewModel());