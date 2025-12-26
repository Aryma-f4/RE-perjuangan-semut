package com.google.android.gms.internal;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.LocalSocket;
import android.net.LocalSocketAddress;
import android.os.Binder;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.view.View;
import com.adobe.air.wand.view.CompanionView;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.common.Scopes;
import com.google.android.gms.games.Game;
import com.google.android.gms.games.GameBuffer;
import com.google.android.gms.games.GameEntity;
import com.google.android.gms.games.GamesClient;
import com.google.android.gms.games.OnGamesLoadedListener;
import com.google.android.gms.games.OnPlayersLoadedListener;
import com.google.android.gms.games.OnSignOutCompleteListener;
import com.google.android.gms.games.Player;
import com.google.android.gms.games.PlayerBuffer;
import com.google.android.gms.games.PlayerEntity;
import com.google.android.gms.games.RealTimeSocket;
import com.google.android.gms.games.achievement.AchievementBuffer;
import com.google.android.gms.games.achievement.OnAchievementUpdatedListener;
import com.google.android.gms.games.achievement.OnAchievementsLoadedListener;
import com.google.android.gms.games.leaderboard.LeaderboardBuffer;
import com.google.android.gms.games.leaderboard.LeaderboardScoreBuffer;
import com.google.android.gms.games.leaderboard.OnLeaderboardMetadataLoadedListener;
import com.google.android.gms.games.leaderboard.OnLeaderboardScoresLoadedListener;
import com.google.android.gms.games.leaderboard.OnScoreSubmittedListener;
import com.google.android.gms.games.leaderboard.SubmitScoreResult;
import com.google.android.gms.games.multiplayer.Invitation;
import com.google.android.gms.games.multiplayer.InvitationBuffer;
import com.google.android.gms.games.multiplayer.OnInvitationReceivedListener;
import com.google.android.gms.games.multiplayer.OnInvitationsLoadedListener;
import com.google.android.gms.games.multiplayer.ParticipantUtils;
import com.google.android.gms.games.multiplayer.realtime.RealTimeMessage;
import com.google.android.gms.games.multiplayer.realtime.RealTimeMessageReceivedListener;
import com.google.android.gms.games.multiplayer.realtime.RealTimeReliableMessageSentListener;
import com.google.android.gms.games.multiplayer.realtime.Room;
import com.google.android.gms.games.multiplayer.realtime.RoomConfig;
import com.google.android.gms.games.multiplayer.realtime.RoomStatusUpdateListener;
import com.google.android.gms.games.multiplayer.realtime.RoomUpdateListener;
import com.google.android.gms.internal.az;
import com.google.android.gms.internal.k;
import java.io.IOException;
import java.security.cert.CertificateException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/* loaded from: classes.dex */
public final class au extends com.google.android.gms.internal.k<az> {
    private final Map<String, bb> dA;
    private PlayerEntity dB;
    private GameEntity dC;
    private final ba dD;
    private boolean dE;
    private final Binder dF;
    private final long dG;
    private final boolean dH;
    private final String dz;
    private final String g;

    abstract class a extends c {
        private final ArrayList<String> dI;

        a(RoomStatusUpdateListener roomStatusUpdateListener, com.google.android.gms.common.data.d dVar, String[] strArr) {
            super(roomStatusUpdateListener, dVar);
            this.dI = new ArrayList<>();
            for (String str : strArr) {
                this.dI.add(str);
            }
        }

        @Override // com.google.android.gms.internal.au.c
        protected void a(RoomStatusUpdateListener roomStatusUpdateListener, Room room) {
            a(roomStatusUpdateListener, room, this.dI);
        }

        protected abstract void a(RoomStatusUpdateListener roomStatusUpdateListener, Room room, ArrayList<String> arrayList);
    }

    final class aa extends a {
        aa(RoomStatusUpdateListener roomStatusUpdateListener, com.google.android.gms.common.data.d dVar, String[] strArr) {
            super(roomStatusUpdateListener, dVar, strArr);
        }

        @Override // com.google.android.gms.internal.au.a
        protected void a(RoomStatusUpdateListener roomStatusUpdateListener, Room room, ArrayList<String> arrayList) {
            roomStatusUpdateListener.onPeersDisconnected(room, arrayList);
        }
    }

    final class ab extends a {
        ab(RoomStatusUpdateListener roomStatusUpdateListener, com.google.android.gms.common.data.d dVar, String[] strArr) {
            super(roomStatusUpdateListener, dVar, strArr);
        }

        @Override // com.google.android.gms.internal.au.a
        protected void a(RoomStatusUpdateListener roomStatusUpdateListener, Room room, ArrayList<String> arrayList) {
            roomStatusUpdateListener.onPeerInvitedToRoom(room, arrayList);
        }
    }

    final class ac extends a {
        ac(RoomStatusUpdateListener roomStatusUpdateListener, com.google.android.gms.common.data.d dVar, String[] strArr) {
            super(roomStatusUpdateListener, dVar, strArr);
        }

        @Override // com.google.android.gms.internal.au.a
        protected void a(RoomStatusUpdateListener roomStatusUpdateListener, Room room, ArrayList<String> arrayList) {
            roomStatusUpdateListener.onPeerJoined(room, arrayList);
        }
    }

    final class ad extends a {
        ad(RoomStatusUpdateListener roomStatusUpdateListener, com.google.android.gms.common.data.d dVar, String[] strArr) {
            super(roomStatusUpdateListener, dVar, strArr);
        }

        @Override // com.google.android.gms.internal.au.a
        protected void a(RoomStatusUpdateListener roomStatusUpdateListener, Room room, ArrayList<String> arrayList) {
            roomStatusUpdateListener.onPeerLeft(room, arrayList);
        }
    }

    final class ae extends at {
        private final OnPlayersLoadedListener dY;

        ae(OnPlayersLoadedListener onPlayersLoadedListener) {
            this.dY = (OnPlayersLoadedListener) com.google.android.gms.internal.s.b(onPlayersLoadedListener, "Listener must not be null");
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void e(com.google.android.gms.common.data.d dVar) {
            au.this.a(au.this.new af(this.dY, dVar));
        }
    }

    final class af extends com.google.android.gms.internal.k<az>.c<OnPlayersLoadedListener> {
        af(OnPlayersLoadedListener onPlayersLoadedListener, com.google.android.gms.common.data.d dVar) {
            super(onPlayersLoadedListener, dVar);
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.c
        public void a(OnPlayersLoadedListener onPlayersLoadedListener, com.google.android.gms.common.data.d dVar) {
            onPlayersLoadedListener.onPlayersLoaded(dVar.getStatusCode(), new PlayerBuffer(dVar));
        }
    }

    final class ag extends com.google.android.gms.internal.k<az>.b<RealTimeReliableMessageSentListener> {
        private final String dZ;
        private final int ea;
        private final int p;

        ag(RealTimeReliableMessageSentListener realTimeReliableMessageSentListener, int i, int i2, String str) {
            super(realTimeReliableMessageSentListener);
            this.p = i;
            this.ea = i2;
            this.dZ = str;
        }

        @Override // com.google.android.gms.internal.k.b
        public void a(RealTimeReliableMessageSentListener realTimeReliableMessageSentListener) {
            if (realTimeReliableMessageSentListener != null) {
                realTimeReliableMessageSentListener.onRealTimeMessageSent(this.p, this.ea, this.dZ);
            }
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    final class ah extends at {
        final RealTimeReliableMessageSentListener eb;

        public ah(RealTimeReliableMessageSentListener realTimeReliableMessageSentListener) {
            this.eb = realTimeReliableMessageSentListener;
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void a(int i, int i2, String str) {
            au.this.a(au.this.new ag(this.eb, i, i2, str));
        }
    }

    final class ai extends c {
        ai(RoomStatusUpdateListener roomStatusUpdateListener, com.google.android.gms.common.data.d dVar) {
            super(roomStatusUpdateListener, dVar);
        }

        @Override // com.google.android.gms.internal.au.c
        public void a(RoomStatusUpdateListener roomStatusUpdateListener, Room room) {
            roomStatusUpdateListener.onRoomAutoMatching(room);
        }
    }

    final class aj extends at {
        private final RoomUpdateListener ec;
        private final RoomStatusUpdateListener ed;
        private final RealTimeMessageReceivedListener ee;

        public aj(RoomUpdateListener roomUpdateListener) {
            this.ec = (RoomUpdateListener) com.google.android.gms.internal.s.b(roomUpdateListener, "Callbacks must not be null");
            this.ed = null;
            this.ee = null;
        }

        public aj(RoomUpdateListener roomUpdateListener, RoomStatusUpdateListener roomStatusUpdateListener, RealTimeMessageReceivedListener realTimeMessageReceivedListener) {
            this.ec = (RoomUpdateListener) com.google.android.gms.internal.s.b(roomUpdateListener, "Callbacks must not be null");
            this.ed = roomStatusUpdateListener;
            this.ee = realTimeMessageReceivedListener;
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void a(com.google.android.gms.common.data.d dVar, String[] strArr) {
            au.this.a(au.this.new ab(this.ed, dVar, strArr));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void b(com.google.android.gms.common.data.d dVar, String[] strArr) {
            au.this.a(au.this.new ac(this.ed, dVar, strArr));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void c(com.google.android.gms.common.data.d dVar, String[] strArr) {
            au.this.a(au.this.new ad(this.ed, dVar, strArr));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void d(com.google.android.gms.common.data.d dVar, String[] strArr) {
            au.this.a(au.this.new z(this.ed, dVar, strArr));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void e(com.google.android.gms.common.data.d dVar, String[] strArr) {
            au.this.a(au.this.new y(this.ed, dVar, strArr));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void f(com.google.android.gms.common.data.d dVar, String[] strArr) {
            au.this.a(au.this.new aa(this.ed, dVar, strArr));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void n(com.google.android.gms.common.data.d dVar) {
            au.this.a(au.this.new am(this.ec, dVar));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void o(com.google.android.gms.common.data.d dVar) {
            au.this.a(au.this.new p(this.ec, dVar));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void onLeftRoom(int statusCode, String externalRoomId) {
            au.this.a(au.this.new u(this.ec, statusCode, externalRoomId));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void onP2PConnected(String participantId) {
            au.this.a(au.this.new w(this.ed, participantId));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void onP2PDisconnected(String participantId) {
            au.this.a(au.this.new x(this.ed, participantId));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void onRealTimeMessageReceived(RealTimeMessage message) {
            ax.a("GamesClient", "RoomBinderCallbacks: onRealTimeMessageReceived");
            au.this.a(au.this.new v(this.ee, message));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void p(com.google.android.gms.common.data.d dVar) {
            au.this.a(au.this.new al(this.ed, dVar));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void q(com.google.android.gms.common.data.d dVar) {
            au.this.a(au.this.new ai(this.ed, dVar));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void r(com.google.android.gms.common.data.d dVar) {
            au.this.a(au.this.new ak(this.ec, dVar));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void s(com.google.android.gms.common.data.d dVar) {
            au.this.a(au.this.new h(this.ed, dVar));
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void t(com.google.android.gms.common.data.d dVar) {
            au.this.a(au.this.new i(this.ed, dVar));
        }
    }

    final class ak extends b {
        ak(RoomUpdateListener roomUpdateListener, com.google.android.gms.common.data.d dVar) {
            super(roomUpdateListener, dVar);
        }

        @Override // com.google.android.gms.internal.au.b
        public void a(RoomUpdateListener roomUpdateListener, Room room, int i) {
            roomUpdateListener.onRoomConnected(i, room);
        }
    }

    final class al extends c {
        al(RoomStatusUpdateListener roomStatusUpdateListener, com.google.android.gms.common.data.d dVar) {
            super(roomStatusUpdateListener, dVar);
        }

        @Override // com.google.android.gms.internal.au.c
        public void a(RoomStatusUpdateListener roomStatusUpdateListener, Room room) {
            roomStatusUpdateListener.onRoomConnecting(room);
        }
    }

    final class am extends b {
        public am(RoomUpdateListener roomUpdateListener, com.google.android.gms.common.data.d dVar) {
            super(roomUpdateListener, dVar);
        }

        @Override // com.google.android.gms.internal.au.b
        public void a(RoomUpdateListener roomUpdateListener, Room room, int i) {
            roomUpdateListener.onRoomCreated(i, room);
        }
    }

    final class an extends at {
        private final OnSignOutCompleteListener ef;

        public an(OnSignOutCompleteListener onSignOutCompleteListener) {
            this.ef = (OnSignOutCompleteListener) com.google.android.gms.internal.s.b(onSignOutCompleteListener, "Listener must not be null");
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void onSignOutComplete() {
            au.this.a(au.this.new ao(this.ef));
        }
    }

    final class ao extends com.google.android.gms.internal.k<az>.b<OnSignOutCompleteListener> {
        public ao(OnSignOutCompleteListener onSignOutCompleteListener) {
            super(onSignOutCompleteListener);
        }

        @Override // com.google.android.gms.internal.k.b
        public void a(OnSignOutCompleteListener onSignOutCompleteListener) {
            onSignOutCompleteListener.onSignOutComplete();
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    final class ap extends at {
        private final OnScoreSubmittedListener eg;

        public ap(OnScoreSubmittedListener onScoreSubmittedListener) {
            this.eg = (OnScoreSubmittedListener) com.google.android.gms.internal.s.b(onScoreSubmittedListener, "Listener must not be null");
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void d(com.google.android.gms.common.data.d dVar) {
            au.this.a(au.this.new aq(this.eg, new SubmitScoreResult(dVar)));
        }
    }

    final class aq extends com.google.android.gms.internal.k<az>.b<OnScoreSubmittedListener> {
        private final SubmitScoreResult eh;

        public aq(OnScoreSubmittedListener onScoreSubmittedListener, SubmitScoreResult submitScoreResult) {
            super(onScoreSubmittedListener);
            this.eh = submitScoreResult;
        }

        @Override // com.google.android.gms.internal.k.b
        public void a(OnScoreSubmittedListener onScoreSubmittedListener) {
            onScoreSubmittedListener.onScoreSubmitted(this.eh.getStatusCode(), this.eh);
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    abstract class b extends com.google.android.gms.internal.k<az>.c<RoomUpdateListener> {
        b(RoomUpdateListener roomUpdateListener, com.google.android.gms.common.data.d dVar) {
            super(roomUpdateListener, dVar);
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.c
        public void a(RoomUpdateListener roomUpdateListener, com.google.android.gms.common.data.d dVar) {
            a(roomUpdateListener, au.this.x(dVar), dVar.getStatusCode());
        }

        protected abstract void a(RoomUpdateListener roomUpdateListener, Room room, int i);
    }

    abstract class c extends com.google.android.gms.internal.k<az>.c<RoomStatusUpdateListener> {
        c(RoomStatusUpdateListener roomStatusUpdateListener, com.google.android.gms.common.data.d dVar) {
            super(roomStatusUpdateListener, dVar);
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.c
        public void a(RoomStatusUpdateListener roomStatusUpdateListener, com.google.android.gms.common.data.d dVar) {
            a(roomStatusUpdateListener, au.this.x(dVar));
        }

        protected abstract void a(RoomStatusUpdateListener roomStatusUpdateListener, Room room);
    }

    final class d extends at {
        private final OnAchievementUpdatedListener dK;

        d(OnAchievementUpdatedListener onAchievementUpdatedListener) {
            this.dK = (OnAchievementUpdatedListener) com.google.android.gms.internal.s.b(onAchievementUpdatedListener, "Listener must not be null");
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void onAchievementUpdated(int statusCode, String achievementId) {
            au.this.a(au.this.new e(this.dK, statusCode, achievementId));
        }
    }

    final class e extends com.google.android.gms.internal.k<az>.b<OnAchievementUpdatedListener> {
        private final String dL;
        private final int p;

        e(OnAchievementUpdatedListener onAchievementUpdatedListener, int i, String str) {
            super(onAchievementUpdatedListener);
            this.p = i;
            this.dL = str;
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.b
        public void a(OnAchievementUpdatedListener onAchievementUpdatedListener) {
            onAchievementUpdatedListener.onAchievementUpdated(this.p, this.dL);
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    final class f extends at {
        private final OnAchievementsLoadedListener dM;

        f(OnAchievementsLoadedListener onAchievementsLoadedListener) {
            this.dM = (OnAchievementsLoadedListener) com.google.android.gms.internal.s.b(onAchievementsLoadedListener, "Listener must not be null");
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void b(com.google.android.gms.common.data.d dVar) {
            au.this.a(au.this.new g(this.dM, dVar));
        }
    }

    final class g extends com.google.android.gms.internal.k<az>.c<OnAchievementsLoadedListener> {
        g(OnAchievementsLoadedListener onAchievementsLoadedListener, com.google.android.gms.common.data.d dVar) {
            super(onAchievementsLoadedListener, dVar);
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.c
        public void a(OnAchievementsLoadedListener onAchievementsLoadedListener, com.google.android.gms.common.data.d dVar) {
            onAchievementsLoadedListener.onAchievementsLoaded(dVar.getStatusCode(), new AchievementBuffer(dVar));
        }
    }

    final class h extends c {
        h(RoomStatusUpdateListener roomStatusUpdateListener, com.google.android.gms.common.data.d dVar) {
            super(roomStatusUpdateListener, dVar);
        }

        @Override // com.google.android.gms.internal.au.c
        public void a(RoomStatusUpdateListener roomStatusUpdateListener, Room room) {
            roomStatusUpdateListener.onConnectedToRoom(room);
        }
    }

    final class i extends c {
        i(RoomStatusUpdateListener roomStatusUpdateListener, com.google.android.gms.common.data.d dVar) {
            super(roomStatusUpdateListener, dVar);
        }

        @Override // com.google.android.gms.internal.au.c
        public void a(RoomStatusUpdateListener roomStatusUpdateListener, Room room) {
            roomStatusUpdateListener.onDisconnectedFromRoom(room);
        }
    }

    final class j extends at {
        private final OnGamesLoadedListener dN;

        j(OnGamesLoadedListener onGamesLoadedListener) {
            this.dN = (OnGamesLoadedListener) com.google.android.gms.internal.s.b(onGamesLoadedListener, "Listener must not be null");
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void g(com.google.android.gms.common.data.d dVar) {
            au.this.a(au.this.new k(this.dN, dVar));
        }
    }

    final class k extends com.google.android.gms.internal.k<az>.c<OnGamesLoadedListener> {
        k(OnGamesLoadedListener onGamesLoadedListener, com.google.android.gms.common.data.d dVar) {
            super(onGamesLoadedListener, dVar);
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.c
        public void a(OnGamesLoadedListener onGamesLoadedListener, com.google.android.gms.common.data.d dVar) {
            onGamesLoadedListener.onGamesLoaded(dVar.getStatusCode(), new GameBuffer(dVar));
        }
    }

    final class l extends at {
        private final OnInvitationReceivedListener dO;

        l(OnInvitationReceivedListener onInvitationReceivedListener) {
            this.dO = onInvitationReceivedListener;
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void k(com.google.android.gms.common.data.d dVar) {
            InvitationBuffer invitationBuffer = new InvitationBuffer(dVar);
            try {
                Invitation invitationFreeze = invitationBuffer.getCount() > 0 ? invitationBuffer.get(0).freeze() : null;
                if (invitationFreeze != null) {
                    au.this.a(au.this.new m(this.dO, invitationFreeze));
                }
            } finally {
                invitationBuffer.close();
            }
        }
    }

    final class m extends com.google.android.gms.internal.k<az>.b<OnInvitationReceivedListener> {
        private final Invitation dP;

        m(OnInvitationReceivedListener onInvitationReceivedListener, Invitation invitation) {
            super(onInvitationReceivedListener);
            this.dP = invitation;
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.b
        public void a(OnInvitationReceivedListener onInvitationReceivedListener) {
            onInvitationReceivedListener.onInvitationReceived(this.dP);
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    final class n extends at {
        private final OnInvitationsLoadedListener dQ;

        n(OnInvitationsLoadedListener onInvitationsLoadedListener) {
            this.dQ = onInvitationsLoadedListener;
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void j(com.google.android.gms.common.data.d dVar) {
            au.this.a(au.this.new o(this.dQ, dVar));
        }
    }

    final class o extends com.google.android.gms.internal.k<az>.c<OnInvitationsLoadedListener> {
        o(OnInvitationsLoadedListener onInvitationsLoadedListener, com.google.android.gms.common.data.d dVar) {
            super(onInvitationsLoadedListener, dVar);
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.c
        public void a(OnInvitationsLoadedListener onInvitationsLoadedListener, com.google.android.gms.common.data.d dVar) {
            onInvitationsLoadedListener.onInvitationsLoaded(dVar.getStatusCode(), new InvitationBuffer(dVar));
        }
    }

    final class p extends b {
        public p(RoomUpdateListener roomUpdateListener, com.google.android.gms.common.data.d dVar) {
            super(roomUpdateListener, dVar);
        }

        @Override // com.google.android.gms.internal.au.b
        public void a(RoomUpdateListener roomUpdateListener, Room room, int i) {
            roomUpdateListener.onJoinedRoom(i, room);
        }
    }

    final class q extends at {
        private final OnLeaderboardScoresLoadedListener dR;

        q(OnLeaderboardScoresLoadedListener onLeaderboardScoresLoadedListener) {
            this.dR = (OnLeaderboardScoresLoadedListener) com.google.android.gms.internal.s.b(onLeaderboardScoresLoadedListener, "Listener must not be null");
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void a(com.google.android.gms.common.data.d dVar, com.google.android.gms.common.data.d dVar2) {
            au.this.a(au.this.new r(this.dR, dVar, dVar2));
        }
    }

    final class r extends com.google.android.gms.internal.k<az>.b<OnLeaderboardScoresLoadedListener> {
        private final com.google.android.gms.common.data.d dS;
        private final com.google.android.gms.common.data.d dT;

        r(OnLeaderboardScoresLoadedListener onLeaderboardScoresLoadedListener, com.google.android.gms.common.data.d dVar, com.google.android.gms.common.data.d dVar2) {
            super(onLeaderboardScoresLoadedListener);
            this.dS = dVar;
            this.dT = dVar2;
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.b
        public void a(OnLeaderboardScoresLoadedListener onLeaderboardScoresLoadedListener) {
            com.google.android.gms.common.data.d dVar;
            com.google.android.gms.common.data.d dVar2;
            com.google.android.gms.common.data.d dVar3 = this.dS;
            com.google.android.gms.common.data.d dVar4 = this.dT;
            if (onLeaderboardScoresLoadedListener != null) {
                try {
                    onLeaderboardScoresLoadedListener.onLeaderboardScoresLoaded(dVar4.getStatusCode(), new LeaderboardBuffer(dVar3), new LeaderboardScoreBuffer(dVar4));
                    dVar = null;
                    dVar2 = null;
                } catch (Throwable th) {
                    if (dVar3 != null) {
                        dVar3.close();
                    }
                    if (dVar4 != null) {
                        dVar4.close();
                    }
                    throw th;
                }
            } else {
                dVar2 = dVar3;
                dVar = dVar4;
            }
            if (dVar2 != null) {
                dVar2.close();
            }
            if (dVar != null) {
                dVar.close();
            }
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
            if (this.dS != null) {
                this.dS.close();
            }
            if (this.dT != null) {
                this.dT.close();
            }
        }
    }

    final class s extends at {
        private final OnLeaderboardMetadataLoadedListener dU;

        s(OnLeaderboardMetadataLoadedListener onLeaderboardMetadataLoadedListener) {
            this.dU = (OnLeaderboardMetadataLoadedListener) com.google.android.gms.internal.s.b(onLeaderboardMetadataLoadedListener, "Listener must not be null");
        }

        @Override // com.google.android.gms.internal.at, com.google.android.gms.internal.ay
        public void c(com.google.android.gms.common.data.d dVar) {
            au.this.a(au.this.new t(this.dU, dVar));
        }
    }

    final class t extends com.google.android.gms.internal.k<az>.c<OnLeaderboardMetadataLoadedListener> {
        t(OnLeaderboardMetadataLoadedListener onLeaderboardMetadataLoadedListener, com.google.android.gms.common.data.d dVar) {
            super(onLeaderboardMetadataLoadedListener, dVar);
        }

        /* JADX INFO: Access modifiers changed from: protected */
        @Override // com.google.android.gms.internal.k.c
        public void a(OnLeaderboardMetadataLoadedListener onLeaderboardMetadataLoadedListener, com.google.android.gms.common.data.d dVar) {
            onLeaderboardMetadataLoadedListener.onLeaderboardMetadataLoaded(dVar.getStatusCode(), new LeaderboardBuffer(dVar));
        }
    }

    final class u extends com.google.android.gms.internal.k<az>.b<RoomUpdateListener> {
        private final String dV;
        private final int p;

        u(RoomUpdateListener roomUpdateListener, int i, String str) {
            super(roomUpdateListener);
            this.p = i;
            this.dV = str;
        }

        @Override // com.google.android.gms.internal.k.b
        public void a(RoomUpdateListener roomUpdateListener) {
            roomUpdateListener.onLeftRoom(this.p, this.dV);
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    final class v extends com.google.android.gms.internal.k<az>.b<RealTimeMessageReceivedListener> {
        private final RealTimeMessage dW;

        v(RealTimeMessageReceivedListener realTimeMessageReceivedListener, RealTimeMessage realTimeMessage) {
            super(realTimeMessageReceivedListener);
            this.dW = realTimeMessage;
        }

        @Override // com.google.android.gms.internal.k.b
        public void a(RealTimeMessageReceivedListener realTimeMessageReceivedListener) {
            ax.a("GamesClient", "Deliver Message received callback");
            if (realTimeMessageReceivedListener != null) {
                realTimeMessageReceivedListener.onRealTimeMessageReceived(this.dW);
            }
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    final class w extends com.google.android.gms.internal.k<az>.b<RoomStatusUpdateListener> {
        private final String dX;

        w(RoomStatusUpdateListener roomStatusUpdateListener, String str) {
            super(roomStatusUpdateListener);
            this.dX = str;
        }

        @Override // com.google.android.gms.internal.k.b
        public void a(RoomStatusUpdateListener roomStatusUpdateListener) {
            if (roomStatusUpdateListener != null) {
                roomStatusUpdateListener.onP2PConnected(this.dX);
            }
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    final class x extends com.google.android.gms.internal.k<az>.b<RoomStatusUpdateListener> {
        private final String dX;

        x(RoomStatusUpdateListener roomStatusUpdateListener, String str) {
            super(roomStatusUpdateListener);
            this.dX = str;
        }

        @Override // com.google.android.gms.internal.k.b
        public void a(RoomStatusUpdateListener roomStatusUpdateListener) {
            if (roomStatusUpdateListener != null) {
                roomStatusUpdateListener.onP2PDisconnected(this.dX);
            }
        }

        @Override // com.google.android.gms.internal.k.b
        protected void d() {
        }
    }

    final class y extends a {
        y(RoomStatusUpdateListener roomStatusUpdateListener, com.google.android.gms.common.data.d dVar, String[] strArr) {
            super(roomStatusUpdateListener, dVar, strArr);
        }

        @Override // com.google.android.gms.internal.au.a
        protected void a(RoomStatusUpdateListener roomStatusUpdateListener, Room room, ArrayList<String> arrayList) {
            roomStatusUpdateListener.onPeersConnected(room, arrayList);
        }
    }

    final class z extends a {
        z(RoomStatusUpdateListener roomStatusUpdateListener, com.google.android.gms.common.data.d dVar, String[] strArr) {
            super(roomStatusUpdateListener, dVar, strArr);
        }

        @Override // com.google.android.gms.internal.au.a
        protected void a(RoomStatusUpdateListener roomStatusUpdateListener, Room room, ArrayList<String> arrayList) {
            roomStatusUpdateListener.onPeerDeclined(room, arrayList);
        }
    }

    public au(Context context, String str, String str2, GooglePlayServicesClient.ConnectionCallbacks connectionCallbacks, GooglePlayServicesClient.OnConnectionFailedListener onConnectionFailedListener, String[] strArr, int i2, View view, boolean z2) {
        super(context, connectionCallbacks, onConnectionFailedListener, strArr);
        this.dE = false;
        this.dz = str;
        this.g = (String) com.google.android.gms.internal.s.d(str2);
        this.dF = new Binder();
        this.dA = new HashMap();
        this.dD = ba.a(this, i2);
        setViewForPopups(view);
        this.dG = hashCode();
        this.dH = z2;
    }

    private void av() {
        this.dB = null;
    }

    private void aw() {
        Iterator<bb> it = this.dA.values().iterator();
        while (it.hasNext()) {
            try {
                it.next().close();
            } catch (IOException e2) {
                ax.a("GamesClient", "IOException:", e2);
            }
        }
        this.dA.clear();
    }

    private bb t(String str) throws IOException {
        bb bbVar;
        try {
            String strV = C().v(str);
            if (strV == null) {
                bbVar = null;
            } else {
                ax.d("GamesClient", "Creating a socket to bind to:" + strV);
                LocalSocket localSocket = new LocalSocket();
                try {
                    localSocket.connect(new LocalSocketAddress(strV));
                    bbVar = new bb(localSocket, str);
                    this.dA.put(str, bbVar);
                } catch (IOException e2) {
                    ax.c("GamesClient", "connect() call failed on socket: " + e2.getMessage());
                    bbVar = null;
                }
            }
            return bbVar;
        } catch (RemoteException e3) {
            ax.c("GamesClient", "Unable to create socket. Service died.");
            return null;
        }
    }

    /* JADX INFO: Access modifiers changed from: private */
    public Room x(com.google.android.gms.common.data.d dVar) {
        com.google.android.gms.games.multiplayer.realtime.a aVar = new com.google.android.gms.games.multiplayer.realtime.a(dVar);
        try {
            return aVar.getCount() > 0 ? aVar.get(0).freeze() : null;
        } finally {
            aVar.close();
        }
    }

    public int a(byte[] bArr, String str, String[] strArr) {
        com.google.android.gms.internal.s.b(strArr, "Participant IDs must not be null");
        try {
            return C().b(bArr, str, strArr);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
            return -1;
        }
    }

    @Override // com.google.android.gms.internal.k
    protected void a(int i2, IBinder iBinder, Bundle bundle) {
        if (i2 == 0 && bundle != null) {
            this.dE = bundle.getBoolean("show_welcome_popup");
        }
        super.a(i2, iBinder, bundle);
    }

    public void a(IBinder iBinder, Bundle bundle) {
        if (isConnected()) {
            try {
                C().a(iBinder, bundle);
            } catch (RemoteException e2) {
                ax.b("GamesClient", "service died");
            }
        }
    }

    @Override // com.google.android.gms.internal.k
    protected void a(ConnectionResult connectionResult) {
        super.a(connectionResult);
        this.dE = false;
    }

    public void a(OnPlayersLoadedListener onPlayersLoadedListener, int i2, boolean z2, boolean z3) {
        try {
            C().a(new ae(onPlayersLoadedListener), i2, z2, z3);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void a(OnAchievementUpdatedListener onAchievementUpdatedListener, String str) {
        d dVar;
        if (onAchievementUpdatedListener == null) {
            dVar = null;
        } else {
            try {
                dVar = new d(onAchievementUpdatedListener);
            } catch (RemoteException e2) {
                ax.b("GamesClient", "service died");
                return;
            }
        }
        C().a(dVar, str, this.dD.aD(), this.dD.aC());
    }

    public void a(OnAchievementUpdatedListener onAchievementUpdatedListener, String str, int i2) {
        d dVar;
        if (onAchievementUpdatedListener == null) {
            dVar = null;
        } else {
            try {
                dVar = new d(onAchievementUpdatedListener);
            } catch (RemoteException e2) {
                ax.b("GamesClient", "service died");
                return;
            }
        }
        C().a(dVar, str, i2, this.dD.aD(), this.dD.aC());
    }

    public void a(OnScoreSubmittedListener onScoreSubmittedListener, String str, long j2) {
        ap apVar;
        if (onScoreSubmittedListener == null) {
            apVar = null;
        } else {
            try {
                apVar = new ap(onScoreSubmittedListener);
            } catch (RemoteException e2) {
                ax.b("GamesClient", "service died");
                return;
            }
        }
        C().a(apVar, str, j2);
    }

    @Override // com.google.android.gms.internal.k
    protected void a(com.google.android.gms.internal.p pVar, k.d dVar) throws RemoteException {
        String string = getContext().getResources().getConfiguration().locale.toString();
        Bundle bundle = new Bundle();
        bundle.putBoolean("com.google.android.gms.games.key.isHeadless", this.dH);
        pVar.a(dVar, GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_VERSION_CODE, getContext().getPackageName(), this.g, x(), this.dz, this.dD.aD(), string, bundle);
    }

    @Override // com.google.android.gms.internal.k
    protected void a(String... strArr) {
        boolean z2 = false;
        boolean z3 = false;
        for (String str : strArr) {
            if (str.equals(Scopes.GAMES)) {
                z3 = true;
            } else if (str.equals("https://www.googleapis.com/auth/games.firstparty")) {
                z2 = true;
            }
        }
        if (z2) {
            com.google.android.gms.internal.s.a(!z3, String.format("Cannot have both %s and %s!", Scopes.GAMES, "https://www.googleapis.com/auth/games.firstparty"));
        } else {
            com.google.android.gms.internal.s.a(z3, String.format("GamesClient requires %s to function.", Scopes.GAMES));
        }
    }

    public void ax() {
        if (isConnected()) {
            try {
                C().ax();
            } catch (RemoteException e2) {
                ax.b("GamesClient", "service died");
            }
        }
    }

    @Override // com.google.android.gms.internal.k
    protected String b() {
        return "com.google.android.gms.games.service.START";
    }

    public void b(OnAchievementUpdatedListener onAchievementUpdatedListener, String str) {
        d dVar;
        if (onAchievementUpdatedListener == null) {
            dVar = null;
        } else {
            try {
                dVar = new d(onAchievementUpdatedListener);
            } catch (RemoteException e2) {
                ax.b("GamesClient", "service died");
                return;
            }
        }
        C().b(dVar, str, this.dD.aD(), this.dD.aC());
    }

    @Override // com.google.android.gms.internal.k
    protected String c() {
        return "com.google.android.gms.games.internal.IGamesService";
    }

    public void clearNotifications(int notificationTypes) {
        try {
            C().clearNotifications(notificationTypes);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    @Override // com.google.android.gms.internal.k, com.google.android.gms.common.GooglePlayServicesClient
    public void connect() throws PackageManager.NameNotFoundException, CertificateException {
        av();
        super.connect();
    }

    public void createRoom(RoomConfig config) {
        try {
            C().a(new aj(config.getRoomUpdateListener(), config.getRoomStatusUpdateListener(), config.getMessageReceivedListener()), this.dF, config.getVariant(), config.getInvitedPlayerIds(), config.getAutoMatchCriteria(), config.isSocketEnabled(), this.dG);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    @Override // com.google.android.gms.internal.k, com.google.android.gms.common.GooglePlayServicesClient
    public void disconnect() {
        this.dE = false;
        if (isConnected()) {
            try {
                az azVarC = C();
                azVarC.ax();
                azVarC.b(this.dG);
                azVarC.a(this.dG);
            } catch (RemoteException e2) {
                ax.b("GamesClient", "Failed to notify client disconnect.");
            }
        }
        aw();
        super.disconnect();
    }

    public Intent getAchievementsIntent() {
        B();
        Intent intent = new Intent("com.google.android.gms.games.VIEW_ACHIEVEMENTS");
        intent.addFlags(CompanionView.kTouchMetaStateIsEraser);
        return aw.b(intent);
    }

    public Intent getAllLeaderboardsIntent() {
        B();
        Intent intent = new Intent("com.google.android.gms.games.VIEW_LEADERBOARDS");
        intent.putExtra("com.google.android.gms.games.GAME_PACKAGE_NAME", this.dz);
        intent.addFlags(CompanionView.kTouchMetaStateIsEraser);
        return aw.b(intent);
    }

    public String getAppId() {
        try {
            return C().getAppId();
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
            return null;
        }
    }

    public String getCurrentAccountName() {
        try {
            return C().getCurrentAccountName();
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
            return null;
        }
    }

    public Game getCurrentGame() {
        B();
        synchronized (this) {
            if (this.dC == null) {
                try {
                    GameBuffer gameBuffer = new GameBuffer(C().aA());
                    try {
                        if (gameBuffer.getCount() > 0) {
                            this.dC = (GameEntity) gameBuffer.get(0).freeze();
                        }
                    } finally {
                        gameBuffer.close();
                    }
                } catch (RemoteException e2) {
                    ax.b("GamesClient", "service died");
                }
            }
        }
        return this.dC;
    }

    public Player getCurrentPlayer() {
        B();
        synchronized (this) {
            if (this.dB == null) {
                try {
                    PlayerBuffer playerBuffer = new PlayerBuffer(C().ay());
                    try {
                        if (playerBuffer.getCount() > 0) {
                            this.dB = (PlayerEntity) playerBuffer.get(0).freeze();
                        }
                    } finally {
                        playerBuffer.close();
                    }
                } catch (RemoteException e2) {
                    ax.b("GamesClient", "service died");
                }
            }
        }
        return this.dB;
    }

    public String getCurrentPlayerId() {
        try {
            return C().getCurrentPlayerId();
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
            return null;
        }
    }

    public Intent getInvitationInboxIntent() {
        B();
        Intent intent = new Intent("com.google.android.gms.games.SHOW_INVITATIONS");
        intent.putExtra("com.google.android.gms.games.GAME_PACKAGE_NAME", this.dz);
        return aw.b(intent);
    }

    public Intent getLeaderboardIntent(String leaderboardId) {
        B();
        Intent intent = new Intent("com.google.android.gms.games.VIEW_LEADERBOARD_SCORES");
        intent.putExtra("com.google.android.gms.games.LEADERBOARD_ID", leaderboardId);
        intent.addFlags(CompanionView.kTouchMetaStateIsEraser);
        return aw.b(intent);
    }

    public RealTimeSocket getRealTimeSocketForParticipant(String roomId, String participantId) {
        if (participantId == null || !ParticipantUtils.z(participantId)) {
            throw new IllegalArgumentException("Bad participant ID");
        }
        bb bbVar = this.dA.get(participantId);
        return (bbVar == null || bbVar.isClosed()) ? t(participantId) : bbVar;
    }

    public Intent getRealTimeWaitingRoomIntent(Room room, int minParticipantsToStart) {
        B();
        Intent intent = new Intent("com.google.android.gms.games.SHOW_REAL_TIME_WAITING_ROOM");
        com.google.android.gms.internal.s.b(room, "Room parameter must not be null");
        intent.putExtra(GamesClient.EXTRA_ROOM, room.freeze());
        com.google.android.gms.internal.s.a(minParticipantsToStart >= 0, "minParticipantsToStart must be >= 0");
        intent.putExtra("com.google.android.gms.games.MIN_PARTICIPANTS_TO_START", minParticipantsToStart);
        return aw.b(intent);
    }

    public Intent getSelectPlayersIntent(int minPlayers, int maxPlayers) {
        B();
        Intent intent = new Intent("com.google.android.gms.games.SELECT_PLAYERS");
        intent.putExtra("com.google.android.gms.games.MIN_SELECTIONS", minPlayers);
        intent.putExtra("com.google.android.gms.games.MAX_SELECTIONS", maxPlayers);
        return aw.b(intent);
    }

    public Intent getSettingsIntent() {
        B();
        Intent intent = new Intent("com.google.android.gms.games.SHOW_SETTINGS");
        intent.putExtra("com.google.android.gms.games.GAME_PACKAGE_NAME", this.dz);
        intent.addFlags(CompanionView.kTouchMetaStateIsEraser);
        return aw.b(intent);
    }

    public void h(String str, int i2) {
        try {
            C().h(str, i2);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void i(String str, int i2) {
        try {
            C().i(str, i2);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void joinRoom(RoomConfig config) {
        try {
            C().a(new aj(config.getRoomUpdateListener(), config.getRoomStatusUpdateListener(), config.getMessageReceivedListener()), this.dF, config.getInvitationId(), config.isSocketEnabled(), this.dG);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void leaveRoom(RoomUpdateListener listener, String roomId) {
        try {
            C().e(new aj(listener), roomId);
            aw();
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void loadAchievements(OnAchievementsLoadedListener listener, boolean forceReload) {
        try {
            C().b(new f(listener), forceReload);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void loadGame(OnGamesLoadedListener listener) {
        try {
            C().d(new j(listener));
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void loadInvitations(OnInvitationsLoadedListener listener) {
        try {
            C().e(new n(listener));
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void loadLeaderboardMetadata(OnLeaderboardMetadataLoadedListener listener, String leaderboardId, boolean forceReload) {
        try {
            C().c(new s(listener), leaderboardId, forceReload);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void loadLeaderboardMetadata(OnLeaderboardMetadataLoadedListener listener, boolean forceReload) {
        try {
            C().c(new s(listener), forceReload);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void loadMoreScores(OnLeaderboardScoresLoadedListener listener, LeaderboardScoreBuffer buffer, int maxResults, int pageDirection) {
        try {
            C().a(new q(listener), buffer.aF().aG(), maxResults, pageDirection);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void loadPlayer(OnPlayersLoadedListener listener, String playerId) {
        try {
            C().c(new ae(listener), playerId);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void loadPlayerCenteredScores(OnLeaderboardScoresLoadedListener listener, String leaderboardId, int span, int leaderboardCollection, int maxResults, boolean forceReload) {
        try {
            C().b(new q(listener), leaderboardId, span, leaderboardCollection, maxResults, forceReload);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void loadTopScores(OnLeaderboardScoresLoadedListener listener, String leaderboardId, int span, int leaderboardCollection, int maxResults, boolean forceReload) {
        try {
            C().a(new q(listener), leaderboardId, span, leaderboardCollection, maxResults, forceReload);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    /* JADX INFO: Access modifiers changed from: protected */
    @Override // com.google.android.gms.internal.k
    /* renamed from: m, reason: merged with bridge method [inline-methods] */
    public az c(IBinder iBinder) {
        return az.a.o(iBinder);
    }

    public void registerInvitationListener(OnInvitationReceivedListener listener) {
        try {
            C().a(new l(listener), this.dG);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public int sendReliableRealTimeMessage(RealTimeReliableMessageSentListener listener, byte[] messageData, String roomId, String recipientParticipantId) {
        try {
            return C().a(new ah(listener), messageData, roomId, recipientParticipantId);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
            return -1;
        }
    }

    public int sendUnreliableRealTimeMessageToAll(byte[] messageData, String roomId) {
        try {
            return C().b(messageData, roomId, (String[]) null);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
            return -1;
        }
    }

    public void setGravityForPopups(int gravity) {
        this.dD.setGravity(gravity);
    }

    public void setUseNewPlayerNotificationsFirstParty(boolean newPlayerStyle) {
        try {
            C().setUseNewPlayerNotificationsFirstParty(newPlayerStyle);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    public void setViewForPopups(View gamesContentView) {
        this.dD.a(gamesContentView);
    }

    public void signOut(OnSignOutCompleteListener listener) {
        an anVar;
        if (listener == null) {
            anVar = null;
        } else {
            try {
                anVar = new an(listener);
            } catch (RemoteException e2) {
                ax.b("GamesClient", "service died");
                return;
            }
        }
        C().a(anVar);
    }

    public void unregisterInvitationListener() {
        try {
            C().b(this.dG);
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
        }
    }

    @Override // com.google.android.gms.internal.k
    protected void y() {
        super.y();
        if (this.dE) {
            this.dD.aB();
            this.dE = false;
        }
    }

    @Override // com.google.android.gms.internal.k
    protected Bundle z() {
        try {
            Bundle bundleZ = C().z();
            if (bundleZ == null) {
                return bundleZ;
            }
            bundleZ.setClassLoader(au.class.getClassLoader());
            return bundleZ;
        } catch (RemoteException e2) {
            ax.b("GamesClient", "service died");
            return null;
        }
    }
}
