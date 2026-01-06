# CI Secrets for Manual Deploy

This project includes a GitHub Actions workflow to manually build the Android APK and upload it to Google Drive using rclone.

Required repository secrets:

- RCLONE_CONF: Contents of your `rclone.conf` file (include the remote configuration for Google Drive). You can generate it locally using `rclone config` and then paste the file contents as a single secret string.
- RCLONE_REMOTE_PATH: The destination remote path, e.g. `gdrive:Apps/StudentManagementBuilds/` where `gdrive` is the remote name from your `rclone.conf`.

How to trigger:

- Go to GitHub → Actions → "Manual Deploy (Android -> Google Drive)" → Run workflow.
- Optional inputs:
  - flutter_channel: defaults to `stable`.
  - build_flavor: set if you build with flavors.

Notes:

- The workflow also uploads the APK as a GitHub build artifact (`android-apk`).
- If you use Android app signing (keystore), ensure it's already configured in your Gradle setup or add secure steps to decrypt and use keystore files.

