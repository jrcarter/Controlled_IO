# Controlled_IO
Files that are open while they exist and closed when they don't

This is a draft response to a request for a library for [Scope-based files](https://forum.ada-lang.io/t/ada-library-wishlist/14/5). Both binary and text I/O is supported. Please comment on whether or not you find this useful.

The library is completely portable. It has been compiled and tested with GNAT and ObjectAda, on Linux and Windows.

Controlled_Test and Controlled_Text are test programs. Both are user-unfriendly file-copy programs. Controlled_Test performs a binary copy; the output should always be identical to the input. Controlled_Text performs a line-by-line copy of text files; the output may have different line terminators than the input.

Controlled_UTF is a user-unfriendly program to convert a native text file to a [Universal Text File](https://github.com/jrcarter/Universal-Text-File).
