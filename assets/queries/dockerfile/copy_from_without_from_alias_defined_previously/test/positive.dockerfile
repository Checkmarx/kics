FROM myimage:tag as dp
COPY --from=dep /binary /
RUN dir c:\