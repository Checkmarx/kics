from myimage:tag as dep
copy --from=dep /binary /
run dir c:\ 