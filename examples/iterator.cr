require "../src/tiktoker"

SecUID = "MS4wLjABAAAA-VASjiXTh7wDDyXvjk10VFhMWUAoxr8bgfO1kAL1-9s"
CURSOR = "0"

iterator = TikToker::ProfileIterator.new(SecUID, CURSOR)

iterator.next # => Page 1
iterator.next # => Page 2
