require 'ffi'

module Facter::Util::Windows::ApiTypes
  module ::FFI
    WIN32_FALSE = 0

    # standard Win32 error codes
    ERROR_SUCCESS = 0
  end

  module ::FFI::Library
    # Wrapper method for attach_function + private
    def attach_function_private(*args)
      attach_function(*args)
      private args[0]
    end
  end

  class ::FFI::Pointer
    NULL_HANDLE = 0

    def read_win32_bool
      # BOOL is always a 32-bit integer in Win32
      # some Win32 APIs return 1 for true, while others are non-0
      read_int32 != FFI::WIN32_FALSE
    end
    #
    alias_method :read_dword, :read_uint32

    def read_handle
      type_size == 4 ? read_uint32 : read_uint64
    end

    def read_wide_string(char_length, dst_encoding = Encoding::UTF_8)
      # char_length is number of wide chars (typically excluding NULLs), *not* bytes
      str = get_bytes(0, char_length * 2).force_encoding('UTF-16LE')
      str.encode(dst_encoding)
    end

    # @param max_char_length [Integer] Maximum number of wide chars to return (typically excluding NULLs), *not* bytes
    # @param null_terminator [Symbol] Number of number of null wchar characters, *not* bytes, that determine the end of the string
    #   null_terminator = :single_null, then the terminating sequence is two bytes of zero.   This is UNIT16 = 0
    #   null_terminator = :double_null, then the terminating sequence is four bytes of zero.  This is UNIT32 = 0
    def read_arbitrary_wide_string_up_to(max_char_length = 512, null_terminator = :single_null)
      if null_terminator != :single_null && null_terminator != :double_null
        raise _("Unable to read wide strings with %{null_terminator} terminal nulls") % { null_terminator: null_terminator }
      end

      terminator_width = null_terminator == :single_null ? 1 : 2
      reader_method = null_terminator == :single_null ? :get_uint16 : :get_uint32

      # Look for a null terminating characters; if found, read up to that null (exclusive)
      (0...max_char_length - terminator_width).each do |i|
        return read_wide_string(i) if send(reader_method, (i * 2)) == 0
      end

      # String is longer than the max; read just to the max
      read_wide_string(max_char_length)
    end

    def read_win32_local_pointer(&block)
      ptr = nil
      begin
        ptr = read_pointer
        yield ptr
      ensure
        if ptr && ! ptr.null?
          if FFI::WIN32::LocalFree(ptr.address) != FFI::Pointer::NULL_HANDLE
            Puppet.debug "LocalFree memory leak"
          end
        end
      end

      # ptr has already had LocalFree called, so nothing to return
      nil
    end
  end
  # FFI Types
  # https://github.com/ffi/ffi/wiki/Types

  # Windows - Common Data Types
  # https://msdn.microsoft.com/en-us/library/cc230309.aspx

  # Windows Data Types
  # https://msdn.microsoft.com/en-us/library/windows/desktop/aa383751(v=vs.85).aspx

  FFI.typedef :uint32, :dword
  FFI.typedef :uintptr_t, :handle

  # buffer_inout is similar to pointer (platform specific), but optimized for buffers
  FFI.typedef :buffer_inout, :lpwstr

  # pointer in FFI is platform specific
  # NOTE: for API calls with reserved lpvoid parameters, pass a FFI::Pointer::NULL
  FFI.typedef :pointer, :lpcvoid
  FFI.typedef :pointer, :lpvoid
  FFI.typedef :pointer, :lpdword
  FFI.typedef :pointer, :pdword
  FFI.typedef :pointer, :phandle
  FFI.typedef :pointer, :pbool

  # any time LONG / ULONG is in a win32 API definition DO NOT USE platform specific width
  # which is what FFI uses by default
  # instead create new aliases for these very special cases
  # NOTE: not a good idea to redefine FFI :ulong since other typedefs may rely on it
  FFI.typedef :uint32, :win32_ulong
  FFI.typedef :int32, :win32_long
  # FFI bool can be only 1 byte at times,
  # Win32 BOOL is a signed int, and is always 4 bytes, even on x64
  # https://blogs.msdn.com/b/oldnewthing/archive/2011/03/28/10146459.aspx
  FFI.typedef :int32, :win32_bool

  # Same as a LONG, a 32-bit signed integer
  FFI.typedef :int32, :hresult

  # NOTE: FFI already defines (u)short as a 16-bit (un)signed like this:
  # FFI.typedef :uint16, :ushort
  # FFI.typedef :int16, :short

  # 8 bits per byte
  FFI.typedef :uchar, :byte
  FFI.typedef :uint16, :wchar

  module ::FFI::WIN32
    extend ::FFI::Library

    ffi_convention :stdcall

    # https://msdn.microsoft.com/en-us/library/windows/desktop/aa366730(v=vs.85).aspx
    # HLOCAL WINAPI LocalFree(
    #   _In_  HLOCAL hMem
    # );
    ffi_lib :kernel32
    attach_function :LocalFree, [:handle], :handle

    # https://msdn.microsoft.com/en-us/library/windows/desktop/ms724211(v=vs.85).aspx
    # BOOL WINAPI CloseHandle(
    #   _In_  HANDLE hObject
    # );
    ffi_lib :kernel32
    attach_function_private :CloseHandle, [:handle], :win32_bool
  end
end
