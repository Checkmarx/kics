FROM myimage:tag as dep
COPY --from=dep /binary /
RUN dir c:\ 