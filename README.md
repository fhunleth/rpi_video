# RpiVideo

This is the start of a simple video player for the Raspberry Pi.

The C source code is currently the Raspberry Pi's `hello_video` sample app with
a `Makefile` that builds with Nerves.

To try, add this project to your deps and add a small `.h264` movie to your
`rootfs_overlay`. Anywhere is fine. If your movie is too big (>100 MB), it will
be too large for the default Nerves images. If that's the case, try uploading it
to the application  partition using `sftp` or some other way. I've been using
[test.h264](https://github.com/raspberrypi/userland/blob/2448644657e5fbfd82299416d218396ee1115ece/host_applications/linux/apps/hello_pi/hello_video/test.h264)

Boot your image and try running:

```elixir
iex> RpiVideo.play("/path/to/test.h264")
```

