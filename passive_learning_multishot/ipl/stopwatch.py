import time

class Stopwatch:
		# Riesumato da: https://github.com/teto1992/declace/blob/91a391c201f2bebd5871f8b2e69984cd8f51992d/declace_simulation_framework/utils/stopwatch.py#L4
    class Trigger:
        def __init__(self, stopwatch, tag):
            self.tag = tag
            self.stopwatch = stopwatch

        def __enter__(self):
            self.start = time.time()

        def __exit__(self, exc_type, exc_val, exc_tb):
            self.stop = time.time()
            elapsed = self.stop - self.start
            self.stopwatch.data[self.tag] = elapsed

    def __init__(self, precision):
        self.data = {}
        self.precision = precision

    def trigger(self, tag):
        return Stopwatch.Trigger(self, tag)

    def get(self, tag):
        return round(self.data[tag], self.precision)

    def clear(self):
        self.data = {}

    @property
    def splits(self):
        for split, elapsed in self.data.items():
            yield split, elapsed
