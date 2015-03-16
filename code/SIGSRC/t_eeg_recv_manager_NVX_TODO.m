classdef t_eeg_recv_manager_NVX < t_eeg_recv_manager_base
% Reads EEG data from Neocortex via ethernet socket


    properties(Constant)
        
        % "CTRL" packet codes
        GeneralControlCode = 	1;
        ServerControlCode =		2;
        ClientControlCode = 	3;

        % "CTRL" packet requests (for GeneralControlCode)
        RequestForVersion = 	1;
        ClosingUp = 			2;
        ServerDisconnected =	3;

        %enum { StartAcquisition=1, StopAcquisition, StartImpedance, ChangeSetup, DCCorrection };

        % "CTRL" packet requests (for ClientControlCode)
        RequestEdfHeader =		1;
        RequestAstFile = 		2;
        RequestStartData =		3;
        RequestStopData = 		4;
        RequestBasicInfo = 		5;

        % "DATA" packet codes
        DataType_InfoBlock =	1;
        DataType_EegData =		2;

        % "DATA" packet requests (for DataType_InfoBlock)
        InfoType_Version =		1;
        InfoType_EdfHeader =	2;
        InfoType_BasicInfo =	3;

        % "DATA" packet requests (for DataType_EegData)
        DataTypeRaw16bit = 		1;
        DataTypeRaw32bit =		2;
        
        code_names = {...
            'GeneralControlCode',...
            'ServerControlCode',...
            'ClientControlCode'};
        
        % Size of pack header in bytes
        pack_head_sz = 12;

        nchan_max = 64;
        
        % Size of socket buffer (TODO!!! space for headers)
        sock_buf_len = 5000;   % in samples
        
    end
    
    
    properties (SetAccess=private)
        
        % DESCRIPRION OF PARAMETERS
        % params.ip
        % params.port
        
        % Size of socket buffer in bytes: (sock_buf_len * nchan_max * 4)
        sock_buf_sz;
        
        ABI;        % AcqBasicInfo
        sock;       % socket
        
    end
    

    % Private
    methods (Access=protected)
        
        %==========================================
        function send_ctrl(obj, code, req)
        % Send command to NVX

            msg_id = 'CTRL';
            sz = 0;

            pack = uint8([uint8(msg_id),...
                fliplr(typecast(uint16(code), 'uint8')),...
                fliplr(typecast(uint16(req), 'uint8')),...
                fliplr(typecast(uint32(sz), 'uint8'))])
            fwrite(obj.sock, pack);

        end
        
        %==========================================
        function [msg_id, code, req, data, len] = get_NVX_packet(obj)
        % Recieve packet from NVX

            % Get header
            pack = fread(obj.sock, obj.pack_head_sz);
            assert(length(pack) == obj.pack_head_sz);

            % Parse header
            msg_id = char(pack(1:4));
            code = typecast(fliplr(uint8(pack(5:6)')), 'uint16');
            req = typecast(fliplr(uint8(pack(7:8)')), 'uint16');
            sz = typecast(fliplr(uint8(pack(9:12)')), 'uint32');
            data = [];

            len = obj.pack_head_sz + sz;

            if sz >= obj.sock_buf_sz
                fprintf('Read error\n');
                len = -1;
                return;
            end
            
            % Get body
            if sz
                data = fread(obj.sock, double(sz));
                %disp(sprintf('recv_len=%i\n', length(data)));
            end

        end
        
        %==========================================
        function parse_AcqBasicInfo(obj, data)
        % Parse packet from NVX that contains protocol info
            
            data = uint8(data);
            obj.ABI.dwSize = typecast(data(1:4), 'uint32');
            obj.ABI.nEegChan = typecast(data(5:8), 'uint32');
            obj.ABI.nEvtChan = typecast(data(9:12), 'uint32');
            obj.ABI.nBlockPnts = typecast(data(13:16), 'uint32');
            obj.ABI.nRate = typecast(data(17:20), 'uint32');
            obj.ABI.nDataSize = typecast(data(21:24), 'uint32');
            obj.ABI.fResolution = typecast(data(25:28), 'single');

        end
        
        %===================================
        function connect(obj)
            
            %%%% Connect (Matlab)
            obj.sock = tcpip(obj.params.ip, obj.params.port, 'InputBufferSize', obj.sock_buf_sz);
            fopen(obj.sock);

            %%%%  Request basic info
            obj.send_ctrl(obj.ClientControlCode, obj.RequestBasicInfo);

            %%%%  Get basic info
            [msg_id, code, req, data] = obj.get_NVX_packet();
            if (code == obj.DataType_InfoBlock) && (req == obj.InfoType_BasicInfo)
                obj.parse_AcqBasicInfo(data);
            else
                fprintf('unexpected msg');
            end
            
        end
        
        %===================================
        function init_spec(obj)
            
            % Connect to NVX
            obj.connect();
            
            % TODO: read channel names from montage file
            
        end
        
    end
    
    
    % Public
    methods
        
        %===================================
        function obj = t_eeg_recv_manager_NVX()
            obj.sock_buf_sz = double(obj.sock_buf_len * obj.nchan_max * 4);
        end
        
        %===================================
        function [nchan_eeg, nchan_mark] = get_nchans(obj)
            nchan_eeg = obj.ABI.nEegChan;
            nchan_mark = double(obj.ABI.nEvtChan);
        end
        
        %===================================
        function srate = get_srate(obj)
            srate = double(obj.ABI.nRate);
        end       
        
        %===================================
        function chan_names = get_chan_names_out(obj)
            
            % bci1 montage
            chan_names = {'Fp1', 'Fp2', 'F3', 'Fz', 'F4', 'Fc3', 'Fcz', 'Fc4', 'T3', 'C3', 'Cz', 'C4',...
                'T4', 'Cp3', 'Cpz', 'Cp4', 'P3', 'Pz', 'P4', 'O1', 'O2', 'A1', 'A2', 'C1', 'C2', 'C5', 'C6', 'Cp1', 'Fc5', 'Cp5', 'Cp2', 'Fc6', 'Cp6'};
            % TODO: read channel names from montage file
            
        end       
        
        %===================================
        function chan_names = get_mark_chan_names_out(obj)
            for n = 1 : length(obj.ABI.nEvtChan)
                chan_names{n} = sprintf('MARK_CHAN_%i', n);
            end
        end
        
        %===================================
        function start_recv(obj)
            obj.send_ctrl(obj.ClientControlCode, obj.RequestStartData);
        end
        
        %===================================
        function restart(obj)
            
            % Clear socket
            while 1==1
                nrecv = obj.sock.BytesAvailable;
                fread(obj.sock, nrecv);
                pause(0.5);
                n = obj.sock.BytesAvailable
                if n ~= nrecv
                    break;
                end
            end
            
        end   
        
        %===================================
        function nsamples_recv = recv_data(obj, buf_eeg, buf_mark)
        % Reads EEG samples & markers from socket
        % buf_eeg and buf_markers  are t_sample_buf objects
        % Size of buffers: buf_eeg(nchans_eeg,nsamples_max)
        % Size of buffers: buf_mark(nchans_mark,nsamples_max)
        % nsamples_recv - number of samples read
        % nsamples_recv_total <- nsamples_recv_total + nsamples_recv
    
            nsamples_recv = 0;
        
            nrecv = obj.sock.BytesAvailable;
            
            %nrecv = max(nrecv,100);

            % Check if socket is empty
            if nrecv == 0
                %fprintf('>>>>>>>>>>>  No data in socket\n');
                return;
            end

            % Check if socket is full
            if nrecv >= obj.sock_buf_sz
                % TODO!!!
                fprintf('>>>>>>>>>>>  Socket overflow\n');
                %assert(0==1);
                obj.restart();
                return;
            end
            %}
            
            % Allocate buffer
            %buf = zeros(obj.ABI.nEegChan + obj.ABI.nEvtChan, obj.ABI.nBlockPnts);
            %buf = [];
            
            % Do we need to clear socket buffer after critical error
            need_reset = 0;

            % Read all data from socket
            while nrecv > 0

                %  Get portion of data from socket (TODO: preallocate)
                [msg_id, code, req, data, len] = obj.get_NVX_packet();
                if len == -1
                    obj.restart();
                    need_reset = 1;
                    break;
                end
                
                    nrecv = nrecv - len;

                % Must be EEG data
                if code ~= obj.DataType_EegData
                    fprintf('Non-data package recieved (code = %i)', code);
                    obj.restart();
                    need_reset = 1;
                    break;
                end
                
                % Check size of data read from socket
                data_sz = length(data);                      % num. of bytes
                data_len = data_sz / obj.ABI.nDataSize;      % num. of values
                nchan_eeg = obj.ABI.nEegChan;
                nchan_mark = obj.ABI.nEvtChan;
                nchan = nchan_eeg + nchan_mark;
                nsamples = data_len / nchan;                 % num. of samples
                if nsamples ~= obj.ABI.nBlockPnts
                    fprintf('Invalid number of samples in package: %f', nsamples);
                    obj.restart();
                    need_reset = 1;
                    break;
                end

                % Convert from byte sequence to integers
                if obj.ABI.nDataSize == 4
                    data = typecast(uint8(data),'int32');
                else
                    data = typecast(uint8(data),'int16');
                end
                
                % Reshape data to (nchan x nsamples)
                data = reshape(data, nchan, nsamples);

                % Assign indices to recieved samples
                sample_idx_new = obj.nsamples_recv_total + [1 : nsamples];
                
                % Add recieved data & markers to memory buffers
                buf_eeg.append(sample_idx_new, data(1:nchan_eeg, :)); 
                buf_mark.append(sample_idx_new, data(nchan_eeg+1:end, :));
 
                % Update number of recieved samples
                nsamples_recv = nsamples_recv + nsamples;
                obj.nsamples_recv_total = obj.nsamples_recv_total + nsamples;

            end
            
            nsamples_recv = double(nsamples_recv);
            
            if need_reset
                obj.restart();
            end
            
        end
        
    end
    
end

