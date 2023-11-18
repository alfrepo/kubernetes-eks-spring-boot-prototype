
// define outputs on which others will depend

output "app_codepipeline_arn" {
    value = "${aws_iam_role.iam_codebuild_role_terra_skelett.arn}"
}