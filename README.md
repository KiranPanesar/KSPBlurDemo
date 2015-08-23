# KSPBlurDemo
A demo of a GPU-based nav bar blur.

I love the Twitter iOS app's nav bar blur on the profile screen. It's incredibly smooth and the blur styling is perfect. I wanted to emulate it to include in one of our applications. I found [this article](http://www.thinkandbuild.it/implementing-the-twitter-ios-app-ui/). It gave more attention to the dynamic positioning of elements than the blur effect. To achieve the blur they are dialing the opacity of a blurred view. This gives a weird effect when the blur view's opactity is < 1.0.

I took on a similar challenge that the article does, but I have focused on a real blur. To achieve this, I am using CoreImage with an OpenGLES context to apply the blur filters. Using an OpenGLES context allows the filtering to be performed on the GPU, rather than the CPU. This means we see abosultely no drop in UI performance. Go ahead, scroll around on the demo project! 💯

A demo can be seen here: https://www.youtube.com/watch?v=MMXlAuPaLrY
