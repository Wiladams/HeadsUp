-- test cl.lua
local ffi = require "ffi"

local ocl = require "OclMan"

local num_entries = 256

lpnum_platforms = ffi.new("int[1]")

-- First find out how many platforms there are
local platform, num = CLGetPlatform()
print(num);


-- Then allocate enough space to hold them,
-- and make the call again

value, len = platform:GetPlatformInfo(CL_PLATFORM_PROFILE);
print("CL_PLATFORM_PROFILE: ", value)

value, len = platform:GetPlatformInfo(CL_PLATFORM_VERSION);
print("CL_PLATFORM_VERSION: ", value)

value, len = platform:GetPlatformInfo(CL_PLATFORM_NAME);
print("CL_PLATFORM_NAME: ", value)

value, len = platform:GetPlatformInfo(CL_PLATFORM_VENDOR);
print("CL_PLATFORM_VENDOR: ", value)

value, len = platform:GetPlatformInfo(CL_PLATFORM_EXTENSIONS);
print("CL_PLATFORM_EXTENSIONS: ", value)


local devices = platform:GetDevices(CL_DEVICE_TYPE_GPU)

if devices ~= nil then
	for i=1,#devices do
		print("Device ID: ", devices[i].ID);

		print("CL_DEVICE_NAME: ", devices[i]:GetInfo(CL_DEVICE_NAME));
		print("CL_DEVICE_VENDOR: ", devices[i]:GetInfo(CL_DEVICE_VENDOR));
		print("CL_DEVICE_PROFILE: ", devices[i]:GetInfo(CL_DEVICE_PROFILE));
		print("CL_DEVICE_VERSION: ", devices[i]:GetInfo(CL_DEVICE_VERSION));
		print("CL_DRIVER_VERSION: ", devices[i]:GetInfo(CL_DRIVER_VERSION));

		print("CL_DEVICE_ADDRESS_BITS: ", devices[i]:GetInfo(CL_DEVICE_ADDRESS_BITS));
		print("CL_DEVICE_AVAILABLE: ", devices[i]:GetInfo(CL_DEVICE_AVAILABLE));
		print("CL_DEVICE_EXTENSIONS: ", devices[i]:GetInfo(CL_DEVICE_EXTENSIONS));
	end
end



function CL_CHECK_ERR(expr, err)
	assert(err == CL_SUCCESS, string.format("OpenCL Error: '%s' returned %d!\n", expr, err))
	return err
end


--void pfn_notify(const char *errinfo, const void *private_info, size_t cb, void *user_data)
function pfn_notify(errinfo, private_info, cb, user_data)
	print(string.format("OpenCL Error (via pfn_notify): %s\n", errinfo));
end

function runkernel(device)
-- reference: http://svn.clifford.at/tools/trunk/examples/cldemo.c

	local context = CLContext():CreateForDevice(device);

	--assert(context.ID ~= nil, "CLContext():CreateForDevice");

	local program_source = [[
		__kernel void simple_demo(__global int *src, __global int *dst, int factor)
		{
			int i = get_global_id(0);
			dst[i] = src[i] * factor;
		}
	]];


	local program = context:CreateProgramFromSource(program_source);
	program:Build();


	local NUM_DATA = 100;
	local buffsize = ffi.sizeof("int")*NUM_DATA;

	local input_buffer = context:CreateBuffer(buffsize, CL_MEM_READ_ONLY);
	local output_buffer = context:CreateBuffer(buffsize, CL_MEM_WRITE_ONLY);

print("Size: ", input_buffer.Size);
print("Handle: ", input_buffer.Handle);

	local factor = 2;
	local lpfactor = ffi.new("int[1]", factor);

	local kernel = program:CreateKernel("simple_demo");

	--kernel:SetIndexedArg(0, input_buffer.Handle, ffi.sizeof("cl_mem"));
	--kernel:SetIndexedArg(1, output_buffer.Handle, ffi.sizeof("cl_mem"));
	--kernel:SetIndexedArg(2, lpfactor, ffi.sizeof("int"));

--[[
	CL_CHECK(clSetKernelArg(kernel, 0, sizeof(input_buffer), &input_buffer));
	CL_CHECK(clSetKernelArg(kernel, 1, sizeof(output_buffer), &output_buffer));
	CL_CHECK(clSetKernelArg(kernel, 2, sizeof(factor), &factor));

	cl_command_queue queue;
	queue = CL_CHECK_ERR(clCreateCommandQueue(context, devices[0], 0, &_err));

	for (int i=0; i<NUM_DATA; i++) {
		CL_CHECK(clEnqueueWriteBuffer(queue, input_buffer, CL_TRUE, i*sizeof(int), sizeof(int), &i, 0, NULL, NULL));
	}

	cl_event kernel_completion;
	size_t global_work_size[1] = { NUM_DATA };
	CL_CHECK(clEnqueueNDRangeKernel(queue, kernel, 1, NULL, global_work_size, NULL, 0, NULL, &kernel_completion));
	CL_CHECK(clWaitForEvents(1, &kernel_completion));
	CL_CHECK(clReleaseEvent(kernel_completion));

	print("Result:");
	local lpdata = ffi.new("int[1]");
	for ( i=0, NUM_DATA-1) do
		CL_CHECK(clEnqueueReadBuffer(queue, output_buffer, CL_TRUE, i*sizeof(int), sizeof(int), &data, 0, NULL, NULL));

		printf(lpdata[0]);
	end
	print("\n");
--]]
--	CL_CHECK(clReleaseMemObject(input_buffer));
--	CL_CHECK(clReleaseMemObject(output_buffer));

--	CL_CHECK(clReleaseKernel(kernel));
--	CL_CHECK(clReleaseProgram(program));
--	CL_CHECK(clReleaseContext(context));

end

runkernel(devices[1]);
