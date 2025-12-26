package com.google.android.gms.games;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.view.View;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.common.Scopes;
import com.google.android.gms.games.achievement.OnAchievementUpdatedListener;
import com.google.android.gms.games.achievement.OnAchievementsLoadedListener;
import com.google.android.gms.games.leaderboard.LeaderboardScoreBuffer;
import com.google.android.gms.games.leaderboard.OnLeaderboardMetadataLoadedListener;
import com.google.android.gms.games.leaderboard.OnLeaderboardScoresLoadedListener;
import com.google.android.gms.games.leaderboard.OnScoreSubmittedListener;
import com.google.android.gms.games.multiplayer.OnInvitationReceivedListener;
import com.google.android.gms.games.multiplayer.OnInvitationsLoadedListener;
import com.google.android.gms.games.multiplayer.realtime.RealTimeReliableMessageSentListener;
import com.google.android.gms.games.multiplayer.realtime.Room;
import com.google.android.gms.games.multiplayer.realtime.RoomConfig;
import com.google.android.gms.games.multiplayer.realtime.RoomUpdateListener;
import com.google.android.gms.internal.au;
import com.google.android.gms.internal.s;
import java.security.cert.CertificateException;
import java.util.List;

/* loaded from: classes.dex */
public final class GamesClient implements GooglePlayServicesClient {
    public static final String EXTRA_EXCLUSIVE_BIT_MASK = "exclusive_bit_mask";
    public static final String EXTRA_INVITATION = "invitation";
    public static final String EXTRA_MAX_AUTOMATCH_PLAYERS = "max_automatch_players";
    public static final String EXTRA_MIN_AUTOMATCH_PLAYERS = "min_automatch_players";
    public static final String EXTRA_PLAYERS = "players";
    public static final String EXTRA_ROOM = "room";
    public static final int MAX_RELIABLE_MESSAGE_LEN = 1400;
    public static final int MAX_UNRELIABLE_MESSAGE_LEN = 1168;
    public static final int NOTIFICATION_TYPES_ALL = -1;
    public static final int NOTIFICATION_TYPES_MULTIPLAYER = 1;
    public static final int NOTIFICATION_TYPE_INVITATION = 1;
    public static final int STATUS_ACHIEVEMENT_NOT_INCREMENTAL = 3002;
    public static final int STATUS_ACHIEVEMENT_UNKNOWN = 3001;
    public static final int STATUS_ACHIEVEMENT_UNLOCKED = 3003;
    public static final int STATUS_ACHIEVEMENT_UNLOCK_FAILURE = 3000;
    public static final int STATUS_CLIENT_RECONNECT_REQUIRED = 2;
    public static final int STATUS_INTERNAL_ERROR = 1;
    public static final int STATUS_INVALID_REAL_TIME_ROOM_ID = 7002;
    public static final int STATUS_LICENSE_CHECK_FAILED = 7;
    public static final int STATUS_MULTIPLAYER_ERROR_CREATION_NOT_ALLOWED = 6000;
    public static final int STATUS_MULTIPLAYER_ERROR_NOT_TRUSTED_TESTER = 6001;
    public static final int STATUS_NETWORK_ERROR_NO_DATA = 4;
    public static final int STATUS_NETWORK_ERROR_OPERATION_DEFERRED = 5;
    public static final int STATUS_NETWORK_ERROR_OPERATION_FAILED = 6;
    public static final int STATUS_NETWORK_ERROR_STALE_DATA = 3;
    public static final int STATUS_OK = 0;
    public static final int STATUS_PARTICIPANT_NOT_CONNECTED = 7003;
    public static final int STATUS_REAL_TIME_CONNECTION_FAILED = 7000;
    public static final int STATUS_REAL_TIME_INACTIVE_ROOM = 7005;
    public static final int STATUS_REAL_TIME_MESSAGE_FAILED = -1;
    public static final int STATUS_REAL_TIME_MESSAGE_SEND_FAILED = 7001;
    public static final int STATUS_REAL_TIME_ROOM_NOT_JOINED = 7004;
    private final au dt;

    public static final class Builder {
        private final GooglePlayServicesClient.ConnectionCallbacks d;
        private String du;
        private View dw;
        private final GooglePlayServicesClient.OnConnectionFailedListener e;
        private final Context mContext;
        private String g = "<<default account>>";
        private String[] f = {Scopes.GAMES};
        private int dv = 49;

        public Builder(Context context, GooglePlayServicesClient.ConnectionCallbacks connectedListener, GooglePlayServicesClient.OnConnectionFailedListener connectionFailedListener) {
            this.mContext = context;
            this.du = context.getPackageName();
            this.d = connectedListener;
            this.e = connectionFailedListener;
        }

        public GamesClient create() {
            return new GamesClient(this.mContext, this.du, this.g, this.d, this.e, this.f, this.dv, this.dw);
        }

        public Builder setAccountName(String accountName) {
            this.g = (String) s.d(accountName);
            return this;
        }

        public Builder setGravityForPopups(int gravity) {
            this.dv = gravity;
            return this;
        }

        public Builder setScopes(String... scopes) {
            this.f = scopes;
            return this;
        }

        public Builder setViewForPopups(View gamesContentView) {
            this.dw = (View) s.d(gamesContentView);
            return this;
        }
    }

    private GamesClient(Context context, String gamePackageName, String accountName, GooglePlayServicesClient.ConnectionCallbacks connectedListener, GooglePlayServicesClient.OnConnectionFailedListener connectionFailedListener, String[] scopes, int gravity, View gamesContentView) {
        this.dt = new au(context, gamePackageName, accountName, connectedListener, connectionFailedListener, scopes, gravity, gamesContentView, false);
    }

    public void clearAllNotifications() {
        this.dt.clearNotifications(-1);
    }

    public void clearNotifications(int notificationTypes) {
        this.dt.clearNotifications(notificationTypes);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void connect() throws PackageManager.NameNotFoundException, CertificateException {
        this.dt.connect();
    }

    public void createRoom(RoomConfig config) {
        this.dt.createRoom(config);
    }

    public void declineRoomInvitation(String invitationId) {
        this.dt.i(invitationId, 0);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void disconnect() {
        this.dt.disconnect();
    }

    public void dismissRoomInvitation(String invitationId) {
        this.dt.h(invitationId, 0);
    }

    public Intent getAchievementsIntent() {
        return this.dt.getAchievementsIntent();
    }

    public Intent getAllLeaderboardsIntent() {
        return this.dt.getAllLeaderboardsIntent();
    }

    public String getAppId() {
        return this.dt.getAppId();
    }

    public String getCurrentAccountName() {
        return this.dt.getCurrentAccountName();
    }

    public Game getCurrentGame() {
        return this.dt.getCurrentGame();
    }

    public Player getCurrentPlayer() {
        return this.dt.getCurrentPlayer();
    }

    public String getCurrentPlayerId() {
        return this.dt.getCurrentPlayerId();
    }

    public Intent getInvitationInboxIntent() {
        return this.dt.getInvitationInboxIntent();
    }

    public Intent getLeaderboardIntent(String leaderboardId) {
        return this.dt.getLeaderboardIntent(leaderboardId);
    }

    public RealTimeSocket getRealTimeSocketForParticipant(String roomId, String participantId) {
        return this.dt.getRealTimeSocketForParticipant(roomId, participantId);
    }

    public Intent getRealTimeWaitingRoomIntent(Room room, int minParticipantsToStart) {
        return this.dt.getRealTimeWaitingRoomIntent(room, minParticipantsToStart);
    }

    public Intent getSelectPlayersIntent(int minPlayers, int maxPlayers) {
        return this.dt.getSelectPlayersIntent(minPlayers, maxPlayers);
    }

    public Intent getSettingsIntent() {
        return this.dt.getSettingsIntent();
    }

    public void incrementAchievement(String id, int numSteps) {
        this.dt.a((OnAchievementUpdatedListener) null, id, numSteps);
    }

    public void incrementAchievementImmediate(OnAchievementUpdatedListener listener, String id, int numSteps) {
        this.dt.a(listener, id, numSteps);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnected() {
        return this.dt.isConnected();
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnecting() {
        return this.dt.isConnecting();
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnectionCallbacksRegistered(GooglePlayServicesClient.ConnectionCallbacks listener) {
        return this.dt.isConnectionCallbacksRegistered(listener);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public boolean isConnectionFailedListenerRegistered(GooglePlayServicesClient.OnConnectionFailedListener listener) {
        return this.dt.isConnectionFailedListenerRegistered(listener);
    }

    public void joinRoom(RoomConfig config) {
        this.dt.joinRoom(config);
    }

    public void leaveRoom(RoomUpdateListener listener, String roomId) {
        this.dt.leaveRoom(listener, roomId);
    }

    public void loadAchievements(OnAchievementsLoadedListener listener, boolean forceReload) {
        this.dt.loadAchievements(listener, forceReload);
    }

    public void loadGame(OnGamesLoadedListener listener) {
        this.dt.loadGame(listener);
    }

    public void loadInvitablePlayers(OnPlayersLoadedListener listener, int pageSize, boolean forceReload) {
        this.dt.a(listener, pageSize, false, forceReload);
    }

    public void loadInvitations(OnInvitationsLoadedListener listener) {
        this.dt.loadInvitations(listener);
    }

    @Deprecated
    public void loadLeaderboardMetadata(OnLeaderboardMetadataLoadedListener listener) {
        loadLeaderboardMetadata(listener, false);
    }

    @Deprecated
    public void loadLeaderboardMetadata(OnLeaderboardMetadataLoadedListener listener, String leaderboardId) {
        loadLeaderboardMetadata(listener, leaderboardId, false);
    }

    public void loadLeaderboardMetadata(OnLeaderboardMetadataLoadedListener listener, String leaderboardId, boolean forceReload) {
        this.dt.loadLeaderboardMetadata(listener, leaderboardId, forceReload);
    }

    public void loadLeaderboardMetadata(OnLeaderboardMetadataLoadedListener listener, boolean forceReload) {
        this.dt.loadLeaderboardMetadata(listener, forceReload);
    }

    public void loadMoreInvitablePlayers(OnPlayersLoadedListener listener, int pageSize) {
        this.dt.a(listener, pageSize, true, false);
    }

    public void loadMoreScores(OnLeaderboardScoresLoadedListener listener, LeaderboardScoreBuffer buffer, int maxResults, int pageDirection) {
        this.dt.loadMoreScores(listener, buffer, maxResults, pageDirection);
    }

    public void loadPlayer(OnPlayersLoadedListener listener, String playerId) {
        this.dt.loadPlayer(listener, playerId);
    }

    public void loadPlayerCenteredScores(OnLeaderboardScoresLoadedListener listener, String leaderboardId, int span, int leaderboardCollection, int maxResults) {
        this.dt.loadPlayerCenteredScores(listener, leaderboardId, span, leaderboardCollection, maxResults, false);
    }

    public void loadPlayerCenteredScores(OnLeaderboardScoresLoadedListener listener, String leaderboardId, int span, int leaderboardCollection, int maxResults, boolean forceReload) {
        this.dt.loadPlayerCenteredScores(listener, leaderboardId, span, leaderboardCollection, maxResults, forceReload);
    }

    public void loadTopScores(OnLeaderboardScoresLoadedListener listener, String leaderboardId, int span, int leaderboardCollection, int maxResults) {
        this.dt.loadTopScores(listener, leaderboardId, span, leaderboardCollection, maxResults, false);
    }

    public void loadTopScores(OnLeaderboardScoresLoadedListener listener, String leaderboardId, int span, int leaderboardCollection, int maxResults, boolean forceReload) {
        this.dt.loadTopScores(listener, leaderboardId, span, leaderboardCollection, maxResults, forceReload);
    }

    public void reconnect() throws PackageManager.NameNotFoundException, CertificateException {
        this.dt.disconnect();
        this.dt.connect();
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void registerConnectionCallbacks(GooglePlayServicesClient.ConnectionCallbacks listener) {
        this.dt.registerConnectionCallbacks(listener);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void registerConnectionFailedListener(GooglePlayServicesClient.OnConnectionFailedListener listener) {
        this.dt.registerConnectionFailedListener(listener);
    }

    public void registerInvitationListener(OnInvitationReceivedListener listener) {
        this.dt.registerInvitationListener(listener);
    }

    public void revealAchievement(String id) {
        this.dt.a((OnAchievementUpdatedListener) null, id);
    }

    public void revealAchievementImmediate(OnAchievementUpdatedListener listener, String id) {
        this.dt.a(listener, id);
    }

    public int sendReliableRealTimeMessage(RealTimeReliableMessageSentListener listener, byte[] messageData, String roomId, String recipientParticipantId) {
        return this.dt.sendReliableRealTimeMessage(listener, messageData, roomId, recipientParticipantId);
    }

    public int sendUnreliableRealTimeMessage(byte[] messageData, String roomId, String recipientParticipantId) {
        return this.dt.a(messageData, roomId, new String[]{recipientParticipantId});
    }

    public int sendUnreliableRealTimeMessage(byte[] messageData, String roomId, List<String> recipientParticipantIds) {
        return this.dt.a(messageData, roomId, (String[]) recipientParticipantIds.toArray(new String[recipientParticipantIds.size()]));
    }

    public int sendUnreliableRealTimeMessageToAll(byte[] messageData, String roomId) {
        return this.dt.sendUnreliableRealTimeMessageToAll(messageData, roomId);
    }

    public void setGravityForPopups(int gravity) {
        this.dt.setGravityForPopups(gravity);
    }

    public void setUseNewPlayerNotificationsFirstParty(boolean newPlayerStyle) {
        this.dt.setUseNewPlayerNotificationsFirstParty(newPlayerStyle);
    }

    public void setViewForPopups(View gamesContentView) {
        s.d(gamesContentView);
        this.dt.setViewForPopups(gamesContentView);
    }

    public void signOut() {
        this.dt.signOut(null);
    }

    public void signOut(OnSignOutCompleteListener listener) {
        this.dt.signOut(listener);
    }

    public void submitScore(String leaderboardId, long score) {
        this.dt.a((OnScoreSubmittedListener) null, leaderboardId, score);
    }

    public void submitScoreImmediate(OnScoreSubmittedListener listener, String leaderboardId, long score) {
        this.dt.a(listener, leaderboardId, score);
    }

    public void unlockAchievement(String id) {
        this.dt.b(null, id);
    }

    public void unlockAchievementImmediate(OnAchievementUpdatedListener listener, String id) {
        this.dt.b(listener, id);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void unregisterConnectionCallbacks(GooglePlayServicesClient.ConnectionCallbacks listener) {
        this.dt.unregisterConnectionCallbacks(listener);
    }

    @Override // com.google.android.gms.common.GooglePlayServicesClient
    public void unregisterConnectionFailedListener(GooglePlayServicesClient.OnConnectionFailedListener listener) {
        this.dt.unregisterConnectionFailedListener(listener);
    }

    public void unregisterInvitationListener() {
        this.dt.unregisterInvitationListener();
    }
}
