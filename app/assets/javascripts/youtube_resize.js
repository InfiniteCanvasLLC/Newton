// By Chris Coyier & tweaked by Mathias Bynens

function InitYouTubeResize(maxHeightEvaluator)
{
    // Find all YouTube videos
    var $allVideos = $("iframe[src^='https://www.youtube.com']"),

        // The element that is fluid width
        $fluidEl = $("#video-container");

    // Figure out and save aspect ratio for each video
    $allVideos.each(function() {

        $(this)
            .data('aspectRatio', this.height / this.width)
            
            // and remove the hard coded width/height
            .removeAttr('height')
            .removeAttr('width');

    });

    // When the window is resized
    // (You'll probably want to debounce this)
    $(window).resize(function() {

        var newWidth = $fluidEl.width();
        
        // Resize all videos according to their own aspect ratio
        $allVideos.each(function() {

            var $el = $(this);

            var newHeight = $el.data('aspectRatio') * newWidth;
            var maxHeight = maxHeightEvaluator();

            if (newHeight > maxHeight)
            {
                newHeight = maxHeight;
                newWidth = newHeight / $el.data('aspectRatio')
            }

            $el
                .width(newWidth)
                .height(newHeight);

        });

    // Kick off one resize to fix all videos on page load
    }).resize();

}