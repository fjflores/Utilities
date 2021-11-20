function pat = str2pat( fileStruct )

[ root, kind, subject, session ] = struct2var( fileStruct );
pat = fullfile( root, kind, subject, session );
