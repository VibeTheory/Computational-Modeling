emb = fastTextWordEmbedding;

wvec = word2vec(emb,'apple');   
vec2word(emb,wvec,50)           % give nearby 50 words in semantic space