

$( document ).ready(function() {

    $("#question_question_type").change(function() {
        console.log("Selected option is " + this.selectedIndex);

        if (this.selectedIndex != 0)
        {
            $(".answer_field").hide();
        }
        else
        {
            $(".answer_field").show();
        }
    })

});