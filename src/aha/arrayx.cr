module Aha
  class ArrayX(T)
    @size : Int64
    @capacity : Int64
    @ptr : T*

    getter :size, :capaicty, :ptr

    def initialize(@capacity, @ptr = Pointer(T).null, @size = 0_i64)
      @capacity = 1_i64 if @capacity <= 0
      @ptr = Pointer(T).malloc(@capacity) if @ptr == Pointer(T).null
    end

    def []=(idx : Int, val : T)
      @ptr[idx] = val
    end

    def [](idx : Int)
      @ptr[idx]
    end

    def initialize(size, val : T)
      @size = size.to_i64
      @capacity = Math.pw2ceil(@size)
      @ptr = Pointer(T).malloc(@capacity)
      (0...@size).each do |i|
        @ptr[i] = val
      end
    end

    def self.from_io(io : IO, format : IO::ByteFormat) : self
      ptr, size, capacity = Aha.ptr_from_io T, io, format, Math.pw2ceil
      self.new(capacity, ptr, size)
    end

    def to_io(io : IO, format : IO::ByteFormat)
      @size.to_io io, format
      (0...@size).each do |i|
        Aha.to_io (@ptr + i).value, T, io, format
      end
    end
  end
end