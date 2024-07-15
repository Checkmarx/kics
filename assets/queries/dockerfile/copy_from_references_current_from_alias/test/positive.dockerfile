FROM myimage:tag AS dep
COPY --from=dep /binary /
RUN dir c:\ 