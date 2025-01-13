from transformers import pipeline

# Load sentiment analysis pipeline
sentiment_analyzer = pipeline("sentiment-analysis")

class TransformersHelper:
    def commentToScore(comment):
        result = sentiment_analyzer(comment)
        score = result[0]['score']
        sentiment = result[0]['label']

        if(sentiment == 'POSITIVE'):
            if(score > 0.95):
                return 5
            else:
                return 4
        elif(sentiment == 'NEGATIVE'):
            if(score > 0.95):
                return 1
            else:
                return 2
        else:
            return 3