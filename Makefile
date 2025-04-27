all:
	ghc Producer.hs -package stompl -package utf8-string -package mime
	ghc Consumer.hs -package stompl -package utf8-string -package mime
